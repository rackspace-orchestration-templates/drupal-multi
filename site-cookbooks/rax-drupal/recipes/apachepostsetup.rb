web_app "drupal" do
  template "drupal.conf.erb"
  docroot node['drupal']['dir']
  server_name node['drupal']['server_name']
  server_aliases node['drupal']['server_aliases']
end

execute "enable-new-site" do
   command "sudo a2ensite drupal.conf"
   notifies :reload, "service[apache2]", :delayed
   only_if do File.exists? "#{node['apache']['dir']}/sites-enabled/default" end
end
