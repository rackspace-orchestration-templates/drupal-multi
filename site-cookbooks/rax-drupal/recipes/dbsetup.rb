# coding: utf-8
#
# Cookbook Name:: rax-drupal
# Recipe:: dbsetup
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
case node['platform_family']
when 'rhel', 'fedora'
  directory "/etc/mysql" do
    recursive true
    mode "0755"
    action :create
  end
  # RHEL/Cent don't have this by default, but do read from it, go ahead and add it so
  # mysql recipe doesn't bomb
end

include_recipe "mysql::client" unless platform_family?('windows') # No MySQL client on Windows

db = node['drupal']['db']

mysql_connection_info = {
  :host     => db['host'],
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database db['database_name'] do
  connection  mysql_connection_info
  action      :create
end

mysql_database_user db['username'] do
  connection    mysql_connection_info
  password      db['database_password']
  host          db['host']
  database_name db['database_name']
  action        :create
end

mysql_database_user db['username'] do
  connection    mysql_connection_info
  database_name db['database_name']
  privileges    [:all]
  host          "10.%"
  action        :grant
end

