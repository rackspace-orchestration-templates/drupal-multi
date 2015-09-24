# TODO

Automatically translate whitespaces (and other non-filename characters) into underscores in
iptables\_ng\_rule name attribute.

## Errors when running kitchen test
```
iptables-ng::lwrp_chain_create_default#test_0003_should apply the specified iptables rules = 0.03 s = .
iptables-ng::lwrp_chain_create_default#test_0002_should enable iptables serices =

[2015-08-22T14:38:19+00:00] WARN: Class Chef::Provider::Service does not declare 'resource_name :service'.
[2015-08-22T14:38:19+00:00] WARN: This will no longer work in Chef 13: you must use 'resource_name' to provide DSL.  0.00 s = E
iptables-ng::lwrp_chain_create_default#test_0001_should set default FORWARD policy to DROP =

[2015-08-22T14:38:19+00:00] WARN: Class Chef::Provider::File does not declare 'resource_name :file'.
[2015-08-22T14:38:19+00:00] WARN: This will no longer work in Chef 13: you must use 'resource_name' to provide DSL.  0.00 s = .
Finished tests in 0.042851s, 70.0103 tests/s, 116.6838 assertions/s.

  1) Error:
iptables-ng::lwrp_chain_create_default#test_0002_should enable iptables serices:
Chef::Exceptions::Override: You must override load_current_resource in #<Chef::Provider::Service:0x0000000c5f2dd0>
    /opt/chef/embedded/apps/chef/lib/chef/provider.rb:95:in `load_current_resource'

Running handlers:
[2015-08-22T14:38:19+00:00] ERROR: Running exception handlers

Running handlers complete
[2015-08-22T14:38:19+00:00] ERROR: Exception handlers complete

Chef Client failed. 50 resources updated in 22.830540755 seconds
[2015-08-22T14:38:19+00:00] FATAL: Stacktrace dumped to /tmp/kitchen/cache/chef-stacktrace.out
[2015-08-22T14:38:19+00:00] ERROR: MiniTest failed with 0 failure(s) and 1 error(s).

Error:
iptables-ng::lwrp_chain_create_default#test_0002_should enable iptables serices:
Chef::Exceptions::Override: You must override load_current_resource in #<Chef::Provider::Service:0x0000000c5f2dd0>
    /opt/chef/embedded/apps/chef/lib/chef/provider.rb:95:in `load_current_resource'
```
