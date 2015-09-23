mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Mysql
  action :install
end

mysql_service 'default' do
  port node[:mysql][:port]
  bind_address node[:mysql][:bind_address]
  initial_root_password node[:mysql][:server_root_password]
  socket '/var/run/mysqld/mysqld.sock'
  action [:create, :start]
end

mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => node[:mysql][:server_root_password],
  :socket => '/var/run/mysql-default/mysqld.sock'
}

mysql_database_user 'root' do
  connection mysql_connection_info
  password node[:mysql][:server_root_password]
  host node[:mysql][:root_network_acl]
  action :grant
end
