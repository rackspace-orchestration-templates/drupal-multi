#
# Cookbook Name:: rax-drupal
# Recipe:: firewall-mysql
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

case node["platform_family"]
when "rhel", "fedora"
  fwfile = "/etc/sysconfig/iptables"
  port = node['mysql']['port'].to_i
  rule = "-I INPUT -p tcp -m tcp --dport #{port} -j ACCEPT"
  execute "Adding iptables rule for #{port}" do
    command "iptables #{rule}"
    not_if "grep \"\\#{rule}\" #{fwfile}"
  end
  # Save iptables rules
  execute "Saving mysql iptables rule set" do
    command "/sbin/service iptables save"
  end
when "debian"
  package "ufw" do
      action :install
  end
  include_recipe "firewall"

  firewall_rule "mysql" do
    port node['mysql']['port'].to_i
    protocol :tcp
    interface node['rax']['mysql']['interface']
  end
else
  include_recipe "firewall"

  firewall_rule "mysql" do
    port node['mysql']['port'].to_i
    protocol :tcp
    interface node['rax']['mysql']['interface']
    action :allow
  end
end
