maintainer 'Rackspace Heat Team'
maintainer_email 'heat@lists.rackspace.com'
license 'Apache 2.0'
description 'Create and configure MySQL Server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'
name 'heatmysql'

depends 'mysql'
depends 'database'
depends 'mysql2_chef_gem'
