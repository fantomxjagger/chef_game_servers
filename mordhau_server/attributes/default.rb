# frozen_string_literal: true

# Cookbook Name:: mordhau_server
# Recipe:: default
# Copyright 2020
# All rights reserved - Do Not Redistribute
# Server build

default['mordhau']['os_pkgs'] = {
  'glibc': {'pkgname': 'glibc'},
  'libstdc++': {'pkgname': 'libstdc++'},
  'firewalld': {'pkgname': 'firewalld'}
}
default['mordhau']['steam']['user'] = 'steam'
default['mordhau']['steam']['group'] = 'steam'
default['mordhau']['steam']['user_shell'] = '/bin/bash'
default['mordhau']['steam']['user_home'] = "/home/#{node['mordhau']['steam']['user']}"
default['mordhau']['steam']['steam_cmd_url_root'] = 'https://steamcdn-a.akamaihd.net/client/installer/'
default['mordhau']['steam']['steam_cmd_package'] = 'steamcmd_linux.tar.gz'
default['mordhau']['steam']['server']['status'] = :start
