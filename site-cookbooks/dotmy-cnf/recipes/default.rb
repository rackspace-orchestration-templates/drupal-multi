template "/root/.my.cnf" do
  source "dotmy.cnf.erb"
  owner "root"
  group "root"
  mode "0600"
  variables ({
    :rootpasswd => node['mysql']['server_root_password']
    :port => node['mysql']['port']
  })
end
