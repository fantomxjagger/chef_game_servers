<<<<<<< HEAD
#
# Cookbook Name:: learn_chef_httpd
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


directory steam_home do
  owner steam_user
  group steam_group
  recursive true
  mode '0755'
  action :create_if_missing
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
  cwd '/home/Steam/'
  user 'steam'
  group 'steam'
  not_if { ::File.exists?('/home/Steam/mordhau/MordhauServer.sh')}
end

templates = node['mordhau']['templates']
templates.each do |_template,details|
  template details['target'] do
    source details['source']
    owner steam_user
    group steam_group
    mode details['mode']
    action create_if_missing
  end
end

# Now it actually starts the Mordhau game server
service 'MordhauServer' do
  start_command 'nohup ./MordhauServer.sh &'
  stop_command 'pkill -9 MordhauServer.sh'
  restart_command 'pkill -9 MordhauServer.sh && nohup ./MordhauServer.sh & || nohup ./MordhauServer.sh &'
  action mordhau_service
end

include 'mordhau_server::yum_repos'
=======
# frozen_string_literal: true

#
# Cookbook Name:: mordhau_server
# Recipe:: default
#
# Copyright (c) 2020 Zach Degelau & Jesse Zitterkopf, All Rights Reserved.
# Include Yum Repos

# Includes necessary Yum Repositories
include 'mordhau_server::yum_repos'

# Installs Package Dependencies for Mordhau Server
packages = node['mordhau']['os_pkgs']
packages.each do |_pkg, details|
  yum_package details['pkgname'] do
    action :install
    version details['pkgver'] if details['pkgver']
  end
end

# Firewall Rules needed - Open 7777,7778,1500 UDP

# Setup Variables
steam_user = node['mordhau']['steam']['user']
steam_group = node['mordhau']['steam']['group']
steam_shell = node['mordhau']['steam']['user_shell']
steam_home = node['mordhau']['steam']['user_home']
# steam_cmd_url = node['mordhau']['steam']['steamcmd_url']
steam_cmd_install_mordhau = node['mordhau']['steam']['steamcmd_install_mordhau']
mordhau_root_dir = node['mordhau']['steam']['mordhau_root_dir']

# Creates Steam User Account on the System
user steam_user do
  comment steam_user
  home steam_home
  shell steam_shell
  password 'steam'
end

# Creates Steams home directory location
directory steam_home do
  owner steam_user
  group steam_group
  mode '0755'
  action :create
end

# Updates BashRC and Bash_Profile for steam user account
templates = node['mordhau']['templates']['initial_templates']
templates.each do |_template, details|
  template details['target'] do
    source details['source']
    owner steam_user
    group steam_group
    mode details['mode']
    action :create
  end
end

# Installs SteamCMD, and Tar Cookbook would be better for this if I could get it to work
execute 'Install SteamCMD' do
  command "curl -sqL #{node['mordhau']['steam']['steamcmd_url']} | tar zxvf -"
  cwd steam_home
  user steam_user
  group steam_group
  not_if { ::File.exist?('/home/Steam/steamcmd.sh') }
end

# Creates Mordhau txt file that SteamCMD needs to install or update Mordhau
templates = node['mordhau']['templates']['mordhau_txt']
templates.each do |_template, details|
  template details['target'] do
    source details['source']
    owner steam_user
    group steam_group
    mode details['mode']
    action :create
  end
end

# SteamCMD Installs Mordhau. PS - Updating this file is the same process, just ran by a CronJob instead.
execute 'FirstTime_Mordhau_Install' do
  command steam_cmd_install_mordhau
  cwd steam_home
  user steam_user
  group steam_group
  not_if { ::File.exist?('/home/steam/mordhau/MordhauServer.sh') }
end

# Create the Mordhau Start Script
templates = node['mordhau']['templates']['mordhau_start_script']
templates.each do |_template, details|
  template details['target'] do
    source details['source']
    owner steam_user
    group steam_group
    mode details['mode']
    action :create
  end
end

# Runs the Mordhau Initial Start Script - First Time Run & Close to Fetch Game.ini and Engine.ini Files
execute 'Initial_Mordhau_Run' do
  command './initial.mordhau.run.sh'
  cwd mordhau_root_dir
  user steam_user
  group steam_group
end

# Edits the Game.ini and Engine.ini files that were created by the initial mordhau start script
templates = node['mordhau']['templates']['mordhau_files']
templates.each do |_template, details|
  template details['target'] do
    source details['source']
    owner steam_user
    group steam_group
    mode details['mode']
    action :create
  end
end
#-----------------------------------------------------------------
# Now it actually starts the Mordhau game server
execute 'Start Mordhau Server' do
  command 'nohup ./MordhauServer.sh &'
  cwd mordhau_root_dir
  user steam_user
  group steam_group
end

#-----------------------------------------------------------------
>>>>>>> 13b72ed5d5b7b4a33159ddaa63d14d6f4de86a0a
