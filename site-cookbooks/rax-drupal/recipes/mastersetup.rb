# coding: utf-8
#
# Cookbook Name:: rax-drupal
# Recipe:: mastersetup
#
# Copyright 2014
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe %w{apache2 apache2::mod_php5 apache2::mod_rewrite apache2::mod_expires}
include_recipe %w{php php::module_mysql php::module_gd}
include_recipe "postfix"
include_recipe "drupal::drush"

# Centos does not include the php-dom extension in it's minimal php install.
case node['platform_family']
when 'rhel', 'fedora'
  package 'php-dom' do
    action :install
  end
  template "#{node['apache']['dir']}/conf.d/ports.conf" do
    source 'ports.conf.erb'
    owner 'root'
    group node['apache']['root_group']
    mode '0644'
    notifies :restart, 'service[apache2]', :delayed
  end

  directory "/etc/mysql" do
    recursive true
    mode "0755"
    action :create
  end
  # CentOS/RHEL don't have this by default, but read from it if it's there
  # go ahead and drop it so the drupal recipe doesn't fail
end

include_recipe "mysql::client"

execute "disable-default-site" do
   command "sudo a2dissite default"
   notifies :reload, "service[apache2]", :delayed
   only_if do File.exists? "#{node['apache']['dir']}/sites-enabled/default" end
end
