# frozen_string_literal: true

#
# Cookbook Name:: mordhau_server
# Recipe:: yum_repos
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
repos = node['mordhau']['yum_repos']
repos.each do |repo, details|
yum_repository details['name'] do
  enabled details['enabled']
  gpgcheck details['gpgcheck']
  gpgkey details['gpgkey']
  mirrorlist details['mirrorlist']
  action :create
end
