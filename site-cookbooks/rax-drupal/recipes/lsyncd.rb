# coding: utf-8

include_recipe 'lsyncd'

if node['rax']['lsyncd']['ssh']['private_key']

  template '/etc/lsyncd/lsyncd.exclusions' do
    source 'lsyncd.exclude.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      exclusions: node['rax']['lsyncd']['exclusions']
    )
  end

  directory File.join(node['drupal']['dir'], '.ssh') do
    owner node['rax']['drupal']['user']
    group node['rax']['drupal']['group']
    mode '0700'
    action :create
  end

  file File.join(node['drupal']['dir'], '.ssh/id_rsa') do
    content node['rax']['lsyncd']['ssh']['private_key']
    owner node['rax']['drupal']['user']
    group node['rax']['drupal']['group']
    mode '0600'
    action :create
  end
end

node['rax']['lsyncd']['clients'].each do |client|
  lsyncd_target client.gsub(/\./, '-') do
    source node['drupal']['dir']
    target node['drupal']['dir']
    user node['rax']['drupal']['user']
    host client
    rsync_opts node['rax']['lsyncd']['rsync_opts']
    exclude_from node['rax']['lsyncd']['excludes_file']
    notifies :restart, 'service[lsyncd]', :delayed
  end
end

service 'lsyncd' do
  action :start
end
