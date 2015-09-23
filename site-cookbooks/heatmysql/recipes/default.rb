mysql_service 'default' do
  port node['mysql']['port']
  bind_address node['mysql']['bind_address']
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end
