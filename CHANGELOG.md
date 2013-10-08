squid Cookbook CHANGELOG
=======================
This file is used to list changes made in each version of the squid cookbook.


v0.2.8
------
### Bug
- **[COOK-3590](https://tickets.opscode.com/browse/COOK-3590)** - Fix hard-coded daemon listen port


v0.2.6
------
Cleanup in 5fc5df4 (v0.2.4) was a bit overzealous:

Ubuntu needs upstart provider specified for the service or reload
failures may occur.

v0.2.4
------
### Bug

- [COOK-2979]: squid cookbook has foodcritic failures
- [COOK-3042]: squid acl incorrect for centos 5

v0.1.0-v0.2.2
--------------
Initial public release and migration from @mattray's repository. Changelog was not created/updated at this time.
