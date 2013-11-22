squid Cookbook
==============
Configures squid as a caching proxy.


Recipes
-------
### default
The default recipe installs squid and sets up simple proxy caching. To configure where the squid service listens for
requests you have a few options. By default, this cookbook will configure squid to listen on all available interfaces
on port 3128 (`node['squid']['port']`). To specify an interface to bind to, use the `node['squid']['listen_interface']`
attribute. If this is defined, squid will only listen on port 3128 on the specified interface, whose IP address is
discovered automatically. If you need a more custom setup, define `node['squid']['http_binds']` as a string or a list
of binds, each of which can be either a port or ipaddress:port format.

The size of objects allowed to be stored has been bumped up to allow for caching of installation files.


Usage
-----
Include the squid recipe on the server.

Databags are able to be used for storing host & url acls and also which hosts/nets are able to access which hosts/url.
By default, this cookbook looks for databags named `squid_urls`, `squid_hosts`, and `squid_acls` to configure allowed
URLs and hosts, and ACLs respectively (as described below). You may wish to change the names of the databags in the
event you wish to run multiple squids with different configs. To do this, set the attributes
`node['squid']['urls_data_bag_name']`, `node['squid']['hosts_data_bag_name']`, and `node['squid']['acls_data_bag_name']`.

Example Databags
----------------
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


License & Authors
-----------------
- Author:: Matt Ray (<matt@opscode.com>)
- Author:: Sean OMeara (<someara@opscode.com>)

```text
Copyright 2012-2013 Opscode, Inc.

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
