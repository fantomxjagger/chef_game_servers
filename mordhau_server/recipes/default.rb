# frozen_string_literal: true

#
# Cookbook Name:: mordhau_server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# Firewall Rules needed - Open 7777,7778,1500 UDP

# setup variables
steam_user = node['mordhau']['steam']['user']
steam_group = node['mordhau']['steam']['group']
steam_shell = node['mordhau']['steam']['user_shell']
steam_home = node['mordhau']['steam']['user_home']
steam_tar = node['mordhau']['steam']['steam_cmd_package']
steam_url = "#{node['mordhau']['steam']['steam_cmd_url_root']}#{steam_tar}"
mordhau_service = node['mordhau']['steam']['server']['status']
mordhau_config_dir = node['mordhau']['steam']['server']['config_dir']

packages = node['mordhau']['os_pkgs']
packages.each do |_pkg, details|
  yum_package details['pkgname'] do
    action :install
    version details['pkgver'] if details['pkgver']
  end
end

user steam_user do
  comment steam_user
  home steam_home
  shell steam_shell
  password 'steam'
end

directories = "#{steam_home} #{mordhau_config_dir}"
directories.each do |directory|
  directory directory do
    owner steam_user
    group steam_group
    recursive true
    mode '0755'
    action :create
  end
end

templates = node['mordhau']['templates']
templates.each do |template,details|
  template details['target'] do
    source details['source']
    owner steam_user
    group steam_group
    mode details['mode']
  end
end

# Download and extract the steamcmd.sh
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

# For Every other update, this job will run in cron once weekly or otherwise.
execute 'FirstTime_Mordhau_Install' do
  command './steamcmd.sh +login anonymous +runscript update_mordhau.txt'
  cwd "#{steam_home}/"
  owner steam_user
  group steam_group
  not_if { ::File.exist?("#{steam_home}/mordhau/MordhauServer.sh") }
end

# Now it actually starts the Mordhau game server
service 'MordhauServer' do
  start_command 'nohup ./MordhauServer.sh &'
  stop_command 'pkill -9 MordhauServer.sh'
  restart_command 'pkill -9 MordhauServer.sh && nohup ./MordhauServer.sh & || nohup ./MordhauServer.sh &'
  action mordhau_service
end

include 'mordhau_server::yum_repos'
