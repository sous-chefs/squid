# squid

Installs and configures Squid as a caching proxy.

## Actions

* `:install` - Installs the package, creates configuration directories, renders configuration,
  initializes cache directories when enabled, and enables and starts the service.
* `:remove` - Stops and disables the service, removes cookbook-managed configuration artifacts,
  and removes the package.

## Properties

* `package_name` - Package to install. Default: `squid`.
* `service_name` - Service to manage. Default: `squid`.
* `config_dir` - Squid configuration directory. Defaults to `/etc/squid`, or
  `/usr/local/etc/squid` on FreeBSD.
* `config_include_dir` - Optional include directory for additional `.conf` files.
* `config_file` - Main Squid configuration file. Default: `<config_dir>/squid.conf`.
* `log_dir` - Squid log directory. Default: `/var/log/squid`.
* `cache_dir` - Squid cache directory. Defaults to `/var/spool/squid`, or `/var/squid/cache` on
  FreeBSD.
* `coredump_dir` - Squid coredump directory. Default: `cache_dir`.
* `port` - HTTP port or ports. Default: `3128`.
* `timeout`, `opts`, `max_file_descriptors` - RHEL sysconfig settings.
* `directives` - Additional lines appended to `squid.conf`.
* `acls_databag_name`, `hosts_databag_name`, `urls_databag_name` - Data bags used for ACL input.
* `host_acls`, `url_acls`, `acls` - Inline ACL arrays added to data bag ACLs.
* `acl_element` - Default ACL element for URL data bag entries. Default: `url_regex`.
* `localnets`, `ssl_ports`, `safe_ports` - Built-in ACL values.
* `enable_safe_ports_restriction`, `enable_connect_restriction`, `http_access_deny_all`,
  `icp_access_deny_all` - Access-control toggles.
* `cache_mem`, `cache_size`, `max_obj_size`, `max_obj_size_unit`, `enable_cache_dir` - Cache
  configuration.
* `logformats`, `access_log_option`, `log_module` - Logging configuration.
* `cache_peer` - Optional raw `cache_peer` line.
* `detected_version` - Optional Squid version override for rendered version-specific directives.
  Defaults to runtime detection with `<package_name> -v`.
* `enable_ldap`, `ldap_host`, `ldap_basedn`, `ldap_binddn`, `ldap_bindpassword`,
  `ldap_searchfilter`, `ldap_version`, `ldap_program`, `ldap_authchildren`, `ldap_authrealm`,
  `ldap_authcredentialsttl` - LDAP authentication configuration.

## Examples

```ruby
squid 'default' do
  cache_size 10
  cache_mem 10
end
```

```ruby
squid 'default' do
  config_include_dir '/etc/squid/conf.d'
  http_access_deny_all false
  icp_access_deny_all false
end
```
