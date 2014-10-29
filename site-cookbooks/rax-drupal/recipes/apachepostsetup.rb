web_app "drupal" do
  template "drupal.conf.erb"
  docroot node['drupal']['dir']
  server_name node['drupal']['servername']
  server_aliases node['drupal']['servername']
end

