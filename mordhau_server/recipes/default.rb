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

# Installs SteamCMD
tar_extract steam_url do
  owner steam_user
  group steam_group
  target_dir steam_home
  creates "#{steam_home}/steamcmd.sh"
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

# Runs the Mordhau Initial Start Script - First Time Run & Close to Fetch Game.ini and Engine.ini Files
service 'MordhauServer' do
  start_command "nohup #{mordhau_root_dir}/MordhauServer.sh & && echo $! > /var/run/mordhau_server.pid"
  stop_command 'kill -9 $(cat /var/run/mordhau_server.pid)&& rm /var/run/mordhau_server.pid'
  restart_command "kill -9 $(cat /var/run/mordhau_server.pid) && rm /var/run/mordhau_server.pid && nohup #{mordhau_root_dir}/MordhauServer.sh & && echo $! > /var/run/mordhau_server.pid || nohup #{mordhau_root_dir}/MordhauServer.sh &"
  action :start
end
#------

# Edits the Game.ini and Engine.ini files that were created by the initial mordhau start script

templates = node['mordhau']['templates']['mordhau_files']
templates.each do |_template, details|
  template details['target'] do
    source details['source']
    owner steam_user
    group steam_group
    mode details['mode']
    action :create
    notifies :stop, 'service[MordhauServer]', :before if ::File.exist?('/var/run/mordhau_server.pid')
    notifies :start, 'service[MordhauServer]', :before
  end
end
------------------------------------------------
