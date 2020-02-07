# frozen_string_literal: true

# Cookbook Name:: mordhau_server
# Recipe:: default
# Copyright (c) 2020 Zach Degelau & Jesse Zitterkopf, All Rights Reserved.
# Server build
#-----------------------------------------------------------------
# Mordhau Game.ini Server Settings
default['mordhau']['game_mode']['playerrespawntime'] = '5.000000'
default['mordhau']['game_mode']['autokickonteamkillamount'] = '5'
default['mordhau']['game_mode']['ballistarespawntime'] = '30.000000'
default['mordhau']['game_mode']['catapultrespawntime'] = '30.000000'
default['mordhau']['game_mode']['horserespawntime'] = '30.000000'
default['mordhau']['game_mode']['damagefactor'] = '1.000000'
default['mordhau']['game_mode']['teamdamagefactor'] = '0.500000'
default['mordhau']['game_mode']['teamdamageflinch'] = '0'
default['mordhau']['game_mode']['maprotation'] = 'FFA_Contraband'
default['mordhau']['game_session']['maxslots'] = '16'
default['mordhau']['game_session']['servername'] = 'Chaos LightSaber Battles'
default['mordhau']['game_session']['serverpassword'] = ''
default['mordhau']['game_session']['servermodauthtoken'] = ''
default['mordhau']['game_session']['adminpassword'] = 'chaos'
default['mordhau']['game_session']['admins'] = '76561198068956531'
default['mordhau']['game_session']['bannedplayers'] = ''
default['mordhau']['game_session']['mutedplayers'] = ''
#-------------------------------------------------------------------
# Mordhau Engine.ini Server Settings
default['mordhau']['engine']['tick_rate'] = '120'
#-------------------------------------------------------------------
# Steam Profile Setup
default['mordhau']['steam']['user'] = 'steam'
default['mordhau']['steam']['group'] = 'steam'
default['mordhau']['steam']['user_shell'] = '/bin/bash'
default['mordhau']['steam']['user_home'] = "/home/#{node['mordhau']['steam']['user']}"
#-------------------------------------------------------------------
# SteamCMD URL
default['mordhau']['steam']['steamcmd_url'] = '"https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"'
#-------------------------------------------------------------------
# SteamCMD Mordhau Installer/Updater
default['mordhau']['steam']['steamcmd_install_mordhau'] = './steamcmd.sh +login anonymous +runscript update_mordhau.txt'
#-------------------------------------------------------------------
# Mordhau Root Directory
default['mordhau']['steam']['mordhau_root_dir'] = "#{['mordhau']['steam']['user_home']}/mordhau"
#-------------------------------------------------------------------
# Mordhau Config directory
default['mordhau']['steam']['mordhau_root_dir']['config_dir'] = "#{node['mordhau']['steam']['mordhau_root_dir']}/Mordhau/Saved/Config/LinuxServer"
#-------------------------------------------------------------------
# Mordhau Templates, in the order in which they are needed.  They are in this order because of dependencies that must be ran first
# Initial Templates - BashRC and Profile
default['mordhau']['templates']['initial_templates'] = {
  '.bashrc': {
    target: "#{node['mordhau']['steam']['user_home']}/.bashrc",
    source: 'steam.bashrc.erb',
    mode: '0644',
  },
  '.bash_profile': {
    target: "#{node['mordhau']['steam']['user_home']}/.bash_profile",
    source: 'steam.bash_profile.erb',
    mode: '0644',
  },
}
#--------------------------------------------------------------------
# Mordhau Text File Steam Calls to initially install the mordhau files
default['mordhau']['templates']['mordhau_txt'] = {
  'update_mordhau.txt': {
    target: "#{node['mordhau']['steam']['user_home']}/update_mordhau.txt",
    source: 'update_mordhau.txt.erb',
    mode: '0755',
  },
}
#--------------------------------------------------------------------
# Initial Mordhau starter script that, when ran gets the Game.ini and the Engine.ini Files
default['mordhau']['templates']['mordhau_start_script'] = {
  'initial.mordhau.run.sh': {
    target: "#{node['mordhau']['steam']['mordhau_root_dir']}/initial.mordhau.run.sh",
    source: 'initial.mordhau.run.erb',
    mode: '0755',
  },
}
#--------------------------------------------------------------------
# Mordhau Game.ini and Engine.ini files that will be overwritten by these templates and attributes at the top
default['mordhau']['templates']['mordhau_files'] = {
  'Game.ini': {
    target: "#{node['mordhau']['steam']['mordhau_root_dir']['config_dir']}/Game.ini",
    source: 'Game.ini.erb',
    mode: '0755',
  },
  ".Engine.ini": {
    target: "#{node['mordhau']['steam']['mordhau_root_dir']['config_dir']}/Engine.ini",
    source: 'Engine.ini.erb',
    mode: '0755',
  },
}

default['mordhau']['os_pkgs'] = {
  'glibc': { 'pkgname': 'glibc' },
  'libstdc++': { 'pkgname': 'libstdc++' },
  #  'firewalld': { 'pkgname': 'firewalld' },
}
