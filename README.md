# squid Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/squid.svg)](https://supermarket.chef.io/cookbooks/squid)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/squid/master.svg)](https://circleci.com/gh/sous-chefs/squid)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures Squid as a caching proxy with the `squid` custom resource.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian 12+
- Ubuntu 22.04+
- RHEL-compatible platforms 8+
- Amazon Linux 2023+
- openSUSE Leap 16+
- FreeBSD 13+

### Chef

- Chef 15.3+

### Cookbooks

- none

## Resources

- [squid](documentation/squid_squid.md)

## Migration

This release removes recipes and attributes in favor of the `squid` custom resource. See
[migration.md](migration.md) for the breaking-change guide.

## Usage

Declare the `squid` resource on the server.

```ruby
squid 'default' do
  cache_size 10
  cache_mem 10
end
```

Databags are able to be used for storing host & url acls and also which hosts/nets are able to access which hosts/url

### LDAP Authentication

- Set `enable_ldap true`.
- Set the LDAP properties for your environment.

  - If you use anonymous bindings, `ldap_binddn` and `ldap_bindpassword` are optional.
  - All other LDAP properties are required.
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

- Set `config_include_dir` to the directory of your additional files, such as `/etc/squid/conf.d`.
- It is recommended that you set `http_access_deny_all false` and `icp_access_deny_all false`
  because the include statement is at the bottom of `squid.conf`. Otherwise `http_access allow`
  statements may not be evaluated in the additional configuration files.

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
