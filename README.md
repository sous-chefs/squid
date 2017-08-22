# squid Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/squid.svg?branch=master)](https://travis-ci.org/chef-cookbooks/squid) [![Cookbook Version](https://img.shields.io/cookbook/v/squid.svg)](https://supermarket.chef.io/cookbooks/squid)

Installs and configures Squid as a caching proxy.

## Requirements

### Platforms

- Debian 7+
- Ubuntu 12.04+
- RHEL/CentOS/Amazon/Scientific 6+
- Fedora
- openSUSE / openSUSE Leap
- FreeBSD 10+

### Chef

- Chef 12.1+

### Cookbooks

- none

## Recipes

### default

The default recipe installs squid and sets up simple proxy caching. As of now, the options you may change are the port (`node['squid']['port']`) and the network the caching proxy is available on the subnet from `node.ipaddress` (ie. "192.168.1.0/24") but may be overridden with `node['squid']['network']`. The size of objects allowed to be stored has been bumped up to allow for caching of installation files. An optional (`node['squid']['cache_peer']`), if set, will be written verbatim to the template. On redhat based platforms, this cookbook supports customizing the max number of file descriptors that Squid may open (`node['squid']['max_file_descriptors']`). The default value is 1024.

## Usage

Include the squid recipe on the server. Other nodes may search for this node as their caching proxy and use the `node.ipaddress` and `node['squid']['port']` to point at it.

Databags are able to be used for storing host & url acls and also which hosts/nets are able to access which hosts/url

### LDAP Authentication

- Set (`node['squid']['enable_ldap']`) to true.
- Modify the ldap attributes for your environment.

  - If you use anonymous bindings, two attributes are optional, ['squid']['ldap_binddn'] and ['squid']['ldap_bindpassword'].
  - All other attributes are required.
  - See <http://wiki.squid-cache.org/ConfigExamples/Authenticate/Ldap> for further help.

- To create the ldap acls in squid.conf, you also need the two ldap_auth databag items as shown in the LDAP Databags below.

## Example Databags

### squid_urls - yubikey item

```javascript
{
  "urls": [
    "^https://api.yubico.com/wsapi/2.0/verify"
  ],
  "id": "yubikey"
}
```

### squid_hosts - bastion item

```javascript
{
  "type": "src",
  "id": "bastion",
  "net": [
    "192.168.0.2/32"
  ]
}
```

### squid_acls - bastion item

```javascript
{
  "id": "bastion",
  "acl": [
    [
      "yubikey",
      "allow"
    ],
    [
      "all",
      "deny"
    ]
  ]
}
```

## LDAP Databags

The following two data bags are only required if you are using LDAP Authentication.

### squid_hosts - ldap_auth item

```javascript
{
  "type": "proxy_auth",
  "id": "ldap_auth",
  "net": [
    "REQUIRED"
  ]
}
```

### squid_acls - ldap_auth item

```javascript
{
  "id": "ldap_auth",
  "acl": [
    [
      "",
      "allow"
    ]
  ]
}
```

### Additional configuration files

- Set (`node['squid']['config_include_dir']`) to the directory of your additional files, ex. /etc/squid/conf.d
- It is recommended that you set `node['squid']['http_access_deny_all']` and `node['squid']['icp_access_deny_all']` to false because the include statement is at the bottom of squid.conf.  Otherwise http_access allow statements may not be evaluated in the additional configuration files.

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2012-2016, Chef Software, Inc.

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
