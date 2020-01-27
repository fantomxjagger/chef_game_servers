#
# Cookbook Name:: learn_chef_httpd
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
package 'glibc.i686'
package 'libstdc++.i686'
package 'firewalld'

# Firewall Rules needed - Open 7777,7778,1500 UDP

user 'steam' do
  comment 'steam'
  home '/home/Steam'
  shell '/bin/bash'
  password 'steam'
end

directory '/home/Steam' do
  owner 'steam'
  group 'steam'
  mode '0755'
  action :create
end

template '/home/Steam/.bashrc' do
  source 'steam.bashrc.erb'
  owner 'steam'
  group 'steam'
  mode '0644'
end

template '/home/Steam/.bash_profile' do
  source 'steam.bash_profile.erb'
  owner 'steam'
  group 'steam'
  mode '0644'
end

execute 'Install SteamCMD' do
  command 'curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -'
  cwd '/home/Steam'
  user 'steam'
  group 'steam'
  not_if { ::File.exists?('/home/Steam/steamcmd.sh')}
end

# ./steamcmd.sh +login anonymous +runscript update_mordhau.txt
template '/home/Steam/update_mordhau.txt' do # ~FC033
  source 'update_mordhau.txt.erb'
  owner 'steam'
  group 'steam'
end

# Mordhau's Server files and get Packages
# For Every other update, this job will run in cron once weekly or otherwise.
execute 'FirstTime_Mordhau_Install' do
  command './steamcmd.sh +login anonymous +runscript update_mordhau.txt'
  cwd '/home/Steam/'
  user 'steam'
  group 'steam'
  not_if { ::File.exists?('/home/Steam/mordhau/MordhauServer.sh')}
end

# Now that the Mordhau Folder is installed, it will create the initial run script
template '/home/Steam/mordhau/initial.mordhau.run.sh' do
  source 'initial.mordhau.run.erb'
  owner 'steam'
  group 'steam'
  mode '0755'
end

# Now it will run the initial script
execute 'Initial_Mordhau_Run' do
  command './initial.mordhau.run.sh'
  cwd '/home/Steam/mordhau'
  user 'steam'
  group 'steam'
end

# Now that the initial script ran it will generate the files below, and now the template will edit them.
template '/home/Steam/mordhau/Mordhau/Saved/Config/LinuxServer/Game.ini' do
  source 'Game.ini.erb'
  owner 'steam'
  group 'steam'
end

template '/home/Steam/mordhau/Mordhau/Saved/Config/LinuxServer/Engine.ini' do
  source 'Engine.ini.erb'
  owner 'steam'
  group 'steam'
end

# Now it actually starts the Mordhau game server
execute 'Start Mordhau Server' do
  command 'nohup ./MordhauServer.sh &'
  cwd '/home/Steam/mordhau'
  user 'steam'
  group 'steam'
end


# Yum Repos for any shit unrelated to this
template '/etc/yum.repos.d/rpmfusion-free-updates.repo' do # ~FC033
  source 'rpmfusion-free-updates.repo.erb'
end

template '/etc/yum.repos.d/rpmfusion-nonfree-updates.repo' do # ~FC033
  source 'rpmfusion-nonfree-updates.repo.erb'
end
