#
# Cookbook Name:: basics
# Recipe:: redhat
#
# Copyright 2012, Cogini
#


# Default is 32MB which is too low to be useful
sysctl_param 'kernel.shmmax' do
    # 64MB
    value 67108864
end


include_recipe 'yum::epel'

node[:basics][:epel_packages].each do |pkg|
    package pkg do
        unless node[:basics][:package_mask].include?(pkg)
            action :install
            options '--enablerepo=epel'
        else
            action :remove
        end
    end
end


%w{ atop ntpd }.each do |srv|
    service srv do
        action [:enable, :start]
        only_if { File.exists?("/etc/init.d/#{srv}") }
    end
end


# Unlock port 1022
package 'policycoreutils-python'

execute 'semanage port -a -t ssh_port_t -p tcp 1022' do
    not_if 'semanage port -l | grep 1022'
end
