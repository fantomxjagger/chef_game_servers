# frozen_string_literal: true

# Cookbook Name:: mordhau_server
# Recipe:: default
# Copyright 2020
# All rights reserved - Do Not Redistribute
# Server build

default['mordhau']['os_pkgs'] = {
  'glibc': { 'pkgname': 'glibc' },
  'libstdc++': { 'pkgname': 'libstdc++' },
  'firewalld': { 'pkgname': 'firewalld' }
}
default['mordhau']['steam']['user'] = 'steam'
default['mordhau']['steam']['group'] = 'steam'
default['mordhau']['steam']['user_shell'] = '/bin/bash'
default['mordhau']['steam']['user_home'] = "/home/#{node['mordhau']['steam']['user']}"
default['mordhau']['steam']['steam_cmd_url_root'] = 'https://steamcdn-a.akamaihd.net/client/installer/'
default['mordhau']['steam']['steam_cmd_package'] = 'steamcmd_linux.tar.gz'
default['mordhau']['steam']['server']['status'] = :start
default['mordhau']['steam']['server']['ticket_rate'] = '60'
default['mordhau']['steam']['server']['game_mode']['playerrespawntime'] = '5.000000'
default['mordhau']['steam']['server']['game_mode']['autokickonteamkillamount'] = '5'
default['mordhau']['steam']['server']['game_mode']['ballistarespawntime'] = '30.000000'
default['mordhau']['steam']['server']['game_mode']['catapultrespawntime'] = '30.000000'
default['mordhau']['steam']['server']['game_mode']['horserespawntime'] = '30.000000'
default['mordhau']['steam']['server']['game_mode']['damagefactor'] = '1.000000'
default['mordhau']['steam']['server']['game_mode']['teamdamagefactor'] = '0.500000'
default['mordhau']['steam']['server']['game_mode']['teamdamageflinch'] = '0'
default['mordhau']['steam']['server']['game_mode']['maprotation'] = 'FFA_Contraband'
default['mordhau']['steam']['server']['game_session']['maxslots'] = '16'
default['mordhau']['steam']['server']['game_session']['servername'] = 'Chaos LightSaber Battles'
default['mordhau']['steam']['server']['game_session']['serverpassword'] = ''
default['mordhau']['steam']['server']['game_session']['servermodauthtoken'] = ''
default['mordhau']['steam']['server']['game_session']['adminpassword'] = 'chaos'
default['mordhau']['steam']['server']['game_session']['admins'] = '76561198068956531'
default['mordhau']['steam']['server']['game_session']['bannedplayers'] = ''
default['mordhau']['steam']['server']['game_session']['mutedplayers'] = ''
