directory node['drupal']['dir'] do
  recursive true
  mode "0755"
  action :create
end
