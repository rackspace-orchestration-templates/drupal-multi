Description
===========

This is a Heat template to deploy Load Balanced Drupal servers with a
backend database server.

Requirements
============
* A Heat provider that supports the following:
  * OS::Heat::ChefSolo
  * OS::Heat::RandomString
  * Rackspace::Cloud::LoadBalancer
  * OS::Heat::ResourceGroup
  * Rackspace::Cloud::Server
  * OS::Nova::KeyPair
* An OpenStack username, password, and tenant id.
* [python-heatclient](https://github.com/openstack/python-heatclient)
`>= v0.2.8`:

```bash
pip install python-heatclient
```

We recommend installing the client within a [Python virtual
environment](http://www.virtualenv.org/).

Parameters
==========
Parameters can be replaced with your own values when standing up a stack. Use
the `-P` flag to specify a custom parameter.

* `username`: Username for the Drupal admin login (Default: admin)
* `master_server_hostname`: Hostname to use for your Drupal web-master server.
  (Default: Drupal-Master)
* `image`: Required: Server image used for all servers that are created as a
  part of this deployment. (Default: Ubuntu 12.04 LTS (Precise Pangolin))
* `child_template`: Location of the child template to use for the Drupal web
  servers (Default:
  https://raw.githubusercontent.com/rackspace-orchestration-templates/drupal-multi/master/drupal-web-server.yaml)
* `web_server_count`: Number of web servers to deploy in addition to the
  web-master (Default: 1)
* `load_balancer_hostname`: Hostname for the Cloud Load Balancer (Default:
  Drupal-Load-Balancer)
* `domain`: Domain to be used with this Drupal site (Default: example.com)
* `master_server_flavor`: Cloud Server size to use for the web-master node. The
  size should be at least one size larger than what you use for the web nodes.
  This server handles all admin calls and will ensure files are synced across
  all other nodes. (Default: 2 GB Performance)
* `database_server_flavor`: Cloud Server size to use for the database server.
  Sizes refer to the amount of RAM allocated to the server. (Default: 4 GB
  Performance)
* `kitchen`: URL for the kitchen to use, fetched using git (Default:
  https://github.com/rackspace-orchestration-templates/drupal-multi)
* `web_server_flavor`: Cloud Server size to use on all of the additional web
  nodes. (Default: 2 GB Performance)
* `database_name`: Drupal database name (Default: drupal)
* `web_server_hostnames`: Hostname to use for all additional Drupal web nodes
  (Default: Drupal-Web%index%)
* `database_server_hostname`: Hostname to use for your Drupal Database Server
  (Default: Drupal-Database)
* `version`: Version of Drupal to install (Default: 7.31)
* `chef_version`: Version of chef client to use (Default: 11.14.6)

Outputs
=======
Once a stack comes online, use `heat output-list` to see all available outputs.
Use `heat output-show <OUTPUT NAME>` to get the value of a specific output.

* `private_key`: SSH Private IP
* `load_balancer_ip`: Load Balancer IP
* `drupal_url`: Drupal URL
* `mysql_root_password`: MySQL Root Password
* `drupal_password`: Drupal Password
* `web_ips`: Web Server IPs
* `database_server_ip`: Database Server IP
* `web_master_ip`: Web-Master IP
* `drupal_user`: Drupal User

For multi-line values, the response will come in an escaped form. To get rid of
the escapes, use `echo -e '<STRING>' > file.txt`. For vim users, a substitution
can be done within a file using `%s/\\n/\r/g`.

Stack Details
=============
#### Getting Started
If you're new to Drupal, check out [Getting started with Drupal 7
administration](https://drupal.org/getting-started/7/admin) or [Getting
started with Drupal 6
administration](https://drupal.org/getting-started/6/admin). The getting
started document will help guide you through the initial steps of checking
your site's status, customizing your site's informaion, adding users, and
more!

#### Logging in via SSH
The private key provided in the passwords section can be used to login as
root via SSH. We have an article on how to use these keys with [Mac OS X and
Linux](http://www.rackspace.com/knowledge_center/article/logging-in-with-a-ssh-private-key-on-linuxmac)
as well as [Windows using
PuTTY](http://www.rackspace.com/knowledge_center/article/logging-in-with-a-ssh-private-key-on-windows).

#### Details of Your Setup
This deployment was stood up using
[chef-solo](http://docs.opscode.com/chef_solo.html). Once the deployment is
up, chef will not run again, so it is safe to modify configurations.

A system user called 'drupal' has been created as a part of this deployment.
There is no password associated with this account. You will need to set a
password for this user if you'd like to use the account for transferring
content, backups, or other purposes. Since the account has no password, no
one will be able to login as this user until a password is set.

Drupal was installed using [Drush](http://drush.ws/about). Drupal is
installed into /var/www/drupal and served by
[Apache](http://httpd.apache.org/). The Apache configuration is in
/etc/apache2/sites-enabled/drupal.conf. Any changes to the configuration
would require a restart of Apache.

[Lsyncd](https://code.google.com/p/lsyncd/) has been in installed to sync
static content across the front end servers. All new content will be
published to the master node and then synced across with lsync to the other
web nodes. When uploading content while migrating a site, you'll only need to
upload the content to the master node. The configuration for lsync can be
found in /etc/lsyncd.

[MySQL](http://www.mysql.com/) is the database backend used in this
deployment. The MySQL root password is included in the password section of
this deployment. If you do lose the password, it is also available in
/root/.my.cnf on the database server itself. MySQL backups are performed
locally by [Holland](http://wiki.hollandbackup.org/). The backups will be
stored in /var/lib/mysqlbackup on the database server.

#### Updating Drupal
Drupal does provide community documentation on [how to
upgrade](https://drupal.org/upgrade) your installation of Drupal. There are
several steps involved with the upgrade process. First, make sure to backup
your site files and your database prior to taking any steps to replace the
core site files. There are number of other tutorials available on places like
YouTube that can also step you though the upgrade/update process. There is
not currently a way to perform these upgrades automatically through the admin
interface. Since you have selected the multi-server option, you will only
need to upgrade the master node, and lsync will take care of syncing
everything to the other web nodes.

#### Migrating an Existing Site
Moving a Drupal site can be both difficult and time consuming. Drupal Modules
such as the [Backup and Migrate
module](http://drupal.org/project/backup_migrate) can help you move your
database content. We recommend backing everything up on both the source and
destination locations before anything is done. The content you want to move
over will be in the 'sites' directory. If you're running a single Drupal
site, you may just need the content of 'sites/default/files' along with your
database. Be careful not to overwrite the settings.php file within your site.
It contains the database configuration for your site.

This deployment has all of the core drupal files in place, and their
permissions are properly set. Be careful with ownership and permissions as
you move things over. If you're unsure, check the original ownership and
permissions of the files in this deployment.

#### Additional Modules
There are over 22,000 modules that have been created by an enaged developer
community. The [modules](https://drupal.org/project/Modules) section on
Drupal's website provides an easy way to search for and research modules.

#### Scaling out
This single server deployment is not well suited to be scaled out.  We
recommend leveraging a multi server option. If content needs to be moved,
instructions above regarding migrating an existing site may help with that
transition.

Contributing
============
There are substantial changes still happening within the [OpenStack
Heat](https://wiki.openstack.org/wiki/Heat) project. Template contribution
guidelines will be drafted in the near future.

License
=======
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
