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

case node['platform_family']
when 'rhel', 'fedora'
  directory "/etc/mysql" do
    recursive true
    mode "0755"
    action :create
  end
  # CentOS/RHEL don't have this by default, but read from it if it's there
  # go ahead and drop it so the drupal recipe doesn't fail
end
