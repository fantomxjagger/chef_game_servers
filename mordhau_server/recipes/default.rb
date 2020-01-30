# frozen_string_literal: true

#
# Cookbook Name:: mordhau_server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
packages = node['mordhau']['os_pkgs']
packages.each do |_pkg, details|
  yum_package details['pkgname'] do
    action :install
    version details['pkgver'] if details['pkgver']
  end
end

# Firewall Rules needed - Open 7777,7778,1500 UDP
# setup variables
steam_user = node['mordhau']['steam']['user']
steam_group = node['mordhau']['steam']['group']
steam_shell = node['mordhau']['steam']['user_shell']
steam_home = node['mordhau']['steam']['user_home']
steam_tar = node['mordhau']['steam']['steam_cmd_package']
steam_url = "#{node['mordhau']['steam']['steam_cmd_url_root']}#{steam_tar}"
mordhau_service = node['mordhau']['steam']['server']['status']

# create steam user and home directory
user steam_user do
  comment steam_user
  home steam_home
  shell steam_shell
  password 'steam'
end

directory steam_home do
  owner steam_user
  group steam_group
  mode '0755'
  action :create
end

# setpu environment profile for steam user
template "#{steam_home}/.bashrc" do
  source 'steam.bashrc.erb'
  owner steam_user
  group steam_group
  mode '0644'
end

template "#{steam_home}/.bash_profile" do
  source 'steam.bash_profile.erb'
  owner steam_user
  group steam_group
  mode '0644'
end

# Doenload and extract the steamcmd.sh
tar_extract steam_url do
  owner steam_user
  group steam_group
  target_dir steam_home
  creates "#{steam_home}/steamcmd.sh"
end

file "#{steam_home}/steamcmd.sh" do
  owner steam_user
  group steam_group
  mode '0755'
end

# ./steamcmd.sh +login anonymous +runscript update_mordhau.txt
template "#{steam_home}/update_mordhau.txt" do # ~FC033
  source 'update_mordhau.txt.erb'
  owner steam_user
  group steam_group
end

# Mordhau's Server files and get Packages
# For Every other update, this job will run in cron once weekly or otherwise.
execute 'FirstTime_Mordhau_Install' do
  command './steamcmd.sh +login anonymous +runscript update_mordhau.txt'
  cwd "#{steam_home}/"
  owner steam_user
  group steam_group
  not_if { ::File.exist?("#{steam_home}/mordhau/MordhauServer.sh") }
end

# Now that the Mordhau Folder is installed, it will create the initial run script
template "#{steam_home}/mordhau/initial.mordhau.run.sh" do
  source 'initial.mordhau.run.erb'
  owner steam_user
  group steam_group
  mode '0755'
end

# Now it will run the initial script
execute 'Initial_Mordhau_Run' do
  command 'nohup ./MordhauServer.sh & sleep 10 && pkill -9 Mordhau'
  cwd "#{steam_home}/mordhau"
  owner steam_user
  group steam_group
end

# Now that the initial script ran it will generate the files below, and now the template will edit them.
template "#{steam_home}/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini" do
  source 'Game.ini.erb'
  owner steam_user
  group steam_group
end

template "#{steam_home}/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini" do
  source 'Engine.ini.erb'
  owner steam_user
  group steam_group
end

# Now it actually starts the Mordhau game server
service 'MordhauServer' do
  start_command 'nohup ./MordhauServer.sh &'
  stop_command 'pkill -9 MordhauServer.sh'
  restart_command 'pkill -9 MordhauServer.sh && nohup ./MordhauServer.sh & || nohup ./MordhauServer.sh &'
  action mordhau_service
end

include mordhau_server::yum_repos
