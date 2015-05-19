squid Cookbook CHANGELOG
=======================
This file is used to list changes made in each version of the squid cookbook.

v0.5.4 (2015-05-19)
-------------------
- [#39] Update versions of squid for RHEL7
- [#38] Added ability to use variable databags per environment, role, etc.

v0.5.3 (2015-02-04)
-------------------
- [#37] Fix errors on RHEL7, Fedora
- [#36] Fix warning when squid >= 3.2
- [#33] Miscellaneous cleanup
- [#31] Remove `node['ipaddress']` as the only way to get the ipaddress.
- [#30] Add metadata for default recipe

v0.5.2 (2014-10-14)
-------------------
- Support LDAP. (@MattMencel)
- Support multiple listen ports. (@MattMencel)
- Support use of other ACL types other than url_regex. (@thoutenbos)
- Fix test harness on Ubuntu. (@juliandunn)

v0.5.1 (2014-09-02)
-------------------
- Support Ubuntu 14.04. (@maciejmajewski)

v0.5.0 (2014-07-25)
-------------------
- Don't assume default interface is 'eth0' (@juliandunn)
- Fix breakage on Fedora (@juliandunn)
- Enable a simple way to add arbitrary directives to the bottom of the squid.conf (@dansweeting)
- Add enable_cache_dir attribute to allow disabling the cache_dir (@phutchins)
- Permit configuration of cache size (@dschlenk)
- Fix all test harnesses, Rubocop violations


v0.4.2 (2014-03-27)
-------------------
- [COOK-4320] - Add support for ubuntu 13 to the squid cookbook


v0.4.0 (2014-02-27)
-------------------
- [COOK-4373] Add conditional output of optional attribute for cache_peer to template
- [COOK-4376] remove duplicated attributes
- [COOK-4377] Generate a sysconfig on Fedora


v0.3.0 (2014-02-18)
-------------------
[COOK-4066] - squid attributes should be default and not set/normal


v0.2.10
-------
### Bug
- **[COOK-3936](https://tickets.chef.io/browse/COOK-3936)** - configure squid cache size on disk
- updating style and test harness


v0.2.8
------
### Bug
- **[COOK-3590](https://tickets.chef.io/browse/COOK-3590)** - Fix hard-coded daemon listen port


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
