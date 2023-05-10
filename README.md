# squid Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/squid.svg)](https://supermarket.chef.io/cookbooks/squid)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/squid/master.svg)](https://circleci.com/gh/sous-chefs/squid)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures Squid as a caching proxy.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian 10+
- Ubuntu 16.04+
- RHEL/CentOS/Scientific 7+
- openSUSE / openSUSE Leap
- FreeBSD 11+

### Chef

- Chef 13+

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

  - If you use anonymous bindings, two attributes are optional, `['squid']['ldap_binddn']` and `['squid']['ldap_bindpassword']`.
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
      "yubikey",
      "deny",
      "!"
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

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
