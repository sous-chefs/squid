# squid Cookbook CHANGELOG

This file is used to list changes made in each version of the squid cookbook.

## 4.0.3 (2018-04-13)

- Fix only_if test around config_include_dir.
- Remove debian 7 testing
- Remove fqdn from the Berksfile
- Test on Chef 13 and 14 in Travis
- Add Testing for Ubuntu 18.04 / Debian 9 and remove Debian 7
- Rework the testing to look more like a wrapper cookbook

## 4.0.2 (2017-12-19)

- Avoid overlapping network definition on startup

## 4.0.1 (2017-11-28)

- Use correct application directories for debian-based distros

## 4.0.0 (2017-10-17)

- Removed the selinux recipe and the selinux cookbook dependency. Let Chef / Squid handle the context instead

## 3.2.0 (2017-09-21)

- Add support for Amazon Linux.
- Allow log_module to be configured for logging to syslog for example

## 3.1.2 (2017-06-27)

- Only configure directive hierarchy_stoplist if squid version is less than 3.5

## 3.1.1 (2017-05-30)

- Revert "Remove repetition of version detection" which causes 2nd run issues

## 3.1.0 (2016-12-30)

- Added include for additional .conf files inside squid.conf.erb template
- Added definition of additional attributes to allow writing of http_access and icp_access deny statement in cookbook

## 3.0.0 (2016-11-25)

- Expand testing and clarify supported platforms
- Remove SmartOS from the readme since we don't test it
- Add selinux compatibility with a new selinux recipe
- Detect version of squid installed by shelling out instead of a fixed case statement

## 2.0.0 (2016-09-09)

- Fixed crash on empty databag
- Allow setting Squid's max file descriptors on redhat platforms
- Allow more customization to localnets, safe ports and ssl ports config
- Allow changing the logformat for access_log
- Fixing a bootstrap timing issue
- Use kitche-docker for integration testing in Travis CI and run foodcritic / cookstyle there as well
- Move squid version parsing to a helper
- Fix node attribute warning
- Expand the specs to test more platforms
- Require Chef 12.1+

## v1.1.1 (2015-09-28)

- Fix the cache directory initialization execute resource to correctly fire on all platforms
- Update contributing and testing docs

## v1.1.0 (2015-09-05)

- Added FreeBSD support
- Removed use of Ruby 1.8.7 hash rockets
- Add Chefspec unit tests
- Documented Chef requirement of 11+

## v1.0.1 (2015-09-02)

- Wrap the new source_issues and issues_url to retain compatibility with Chef 11
- Update the contributing documentation to the latest version
- Update Travis config to perform just linting and unit testing

## v1.0.0 (2015-09-02)

- Reorder config to place maximum_object_size before cache_dir so it's not ignored
- Remove attributes for Ubuntu 10.04 which is now EoL
- Remove attributes for Debian 6 which is now EoL
- Merge Debian and Ubuntu attributes to properly assign Debian style directories on Debian systems
- Add squid version attributes for Debian 7.X and 8.X
- Remove RHEL 5.X support from the readme since the current configuration will not start
- Update Test Kitchen for the latest platforms
- Add Ruby 2.0 and 2.2 to Travis
- Add source_url and issues_url to the metadata.rb
- Update the development dependencies in the Gemfile to the latest releases
- Add Travis and cookbook release badges to the readme
- Add required platforms to the readme
- Add rvm, rbenv and rubymine files to the gitignore file
- Add a very basic Serverspec test to Test Kitchen to ensure Squid is up and listening on port 3128
- Converge Test Kitchen instances with a very small memory and disk cache to avoid failures

## v0.6.0 (2015-09-01)

- 0.6.0 was folded into 1.0.0 when it was realized the breaking changes in the release better warranted a 1.0.0 release.

## v0.5.4 (2015-05-19)

- [#39] Update versions of squid for RHEL7
- [#38] Added ability to use variable databags per environment, role, etc.

## v0.5.3 (2015-02-04)

- [#37] Fix errors on RHEL7, Fedora
- [#36] Fix warning when squid >= 3.2
- [#33] Miscellaneous cleanup
- [#31] Remove `node['ipaddress']` as the only way to get the ipaddress.
- [#30] Add metadata for default recipe

## v0.5.2 (2014-10-14)

- Support LDAP. (@MattMencel)
- Support multiple listen ports. (@MattMencel)
- Support use of other ACL types other than url_regex. (@thoutenbos)
- Fix test harness on Ubuntu. (@juliandunn)

## v0.5.1 (2014-09-02)

- Support Ubuntu 14.04\. (@maciejmajewski)

## v0.5.0 (2014-07-25)

- Don't assume default interface is 'eth0' (@juliandunn)
- Fix breakage on Fedora (@juliandunn)
- Enable a simple way to add arbitrary directives to the bottom of the squid.conf (@dansweeting)
- Add enable_cache_dir attribute to allow disabling the cache_dir (@phutchins)
- Permit configuration of cache size (@dschlenk)
- Fix all test harnesses, Rubocop violations

## v0.4.2 (2014-03-27)

- [COOK-4320] - Add support for ubuntu 13 to the squid cookbook

## v0.4.0 (2014-02-27)

- [COOK-4373] Add conditional output of optional attribute for cache_peer to template
- [COOK-4376] remove duplicated attributes
- [COOK-4377] Generate a sysconfig on Fedora

## v0.3.0 (2014-02-18)

[COOK-4066] - squid attributes should be default and not set/normal

## v0.2.10

### Bug

- **[COOK-3936](https://tickets.chef.io/browse/COOK-3936)** - configure squid cache size on disk
- updating style and test harness

## v0.2.8

### Bug

- **[COOK-3590](https://tickets.chef.io/browse/COOK-3590)** - Fix hard-coded daemon listen port

## v0.2.6

Cleanup in 5fc5df4 (v0.2.4) was a bit overzealous:

Ubuntu needs upstart provider specified for the service or reload failures may occur.

## v0.2.4

### Bug

- [COOK-2979]: squid cookbook has foodcritic failures
- [COOK-3042]: squid acl incorrect for centos 5

## v0.1.0-v0.2.2

Initial public release and migration from @mattray's repository. Changelog was not created/updated at this time.
