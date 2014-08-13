# coding: utf-8
#
# Cookbook Name:: rax-drupal
# Recipe:: user
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

group node['rax']['drupal']['group'] do
  action :create
end

user node['rax']['drupal']['user'] do
  action :create
  comment 'Drupal user'
  home node['drupal']['dir']
  gid node['rax']['drupal']['group']
  shell '/bin/bash'
end

group node['apache']['group'] do
  append true
  members node['rax']['drupal']['user']
  action :modify
end

execute 'Setup the various Drupal file system permissions' do
  command <<-EOH
  # Give permissions to the entire directory Drupal install to the Drupal user
  chown -R \
  #{node['rax']['drupal']['user']}:#{node['rax']['drupal']['user']['group']} \
  #{node['drupal']['dir']}

  chmod 664 #{File.join(node['drupal']['dir'], 'sites/default/settings.php')}

  # Set wp-content permissions
  chown -R \
  #{node['rax']['drupal']['user']}:#{node['apache']['group']} \
  #{File.join(node['drupal']['dir'], 'sites/default/files/')}

  find #{File.join(node['drupal']['dir'], 'sites/default/files/')} -type d -print | \
  xargs chmod 775

  find #{File.join(node['drupal']['dir'], 'sites/default/files/')} -type f -print | \
  xargs chmod 664

  chmod 2775 #{File.join(node['drupal']['dir'], 'sites/default/files/')}
  EOH
  action :run
end

