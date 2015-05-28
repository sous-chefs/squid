squid Cookbook
==============
Configures squid as a caching proxy.


Recipes
-------
### default
The default recipe installs squid and sets up simple proxy caching. As of now, the options you may change are the port and ip address which squid should listen on (`node['squid']['listen]`).
An optional (`node['squid']['cache_peer']`), if set, will be written verbatim to the template.


Usage
-----
Include the squid recipe on the server. Other nodes may search for this node as their caching proxy and use `node['squid']['listen]` to point at it. But strongly recommended to manualy specify proxy server address on clients nodes.

Attributes can be used for storing ACLs, http\_access, refresh\_patterns, cache\_peers, icp\_access, htcp\_access and others config options.

### LDAP Authentication

* Set (`node['squid']['enable_ldap']`) to true.
* Modify the ldap attributes for your environment.
  * If you use anonymous bindings, two attributes are optional, ['squid']['ldap_binddn'] and ['squid']['ldap_bindpassword'].
  * All other attributes are required.
  * See http://wiki.squid-cache.org/ConfigExamples/Authenticate/Ldap for further help.
* To create the ldap acls in squid.conf, you also need the two ldap\_auth databag items as shown in the LDAP Databags below.

Example Attributes
----------------
### acls
```ruby
'acls' => {
  'office_net' => {
    'is_external' => false, # false by default
    'modificators' => '', # according to acl type you can specify different
                          # modificators, like -i, -s or others
    'type' => 'src',
    'value' => '192.168.1.0/24'
  }
}
```

### http\_access
```ruby
'http_access' => [
  {
    'action' => 'allow',
    'acls' => ['all']
  }
]
```

### refresh\_patterns
```ruby
'refresh_patterns' => {
  '(Release|Package(.gz)*)$' => {
    'min'=> 0,
    'percent' => '20%',
    'max' => 2880,
    'ignore_case' => true # false by defalut
}
```

### cache\_peers
```ruby
'cache_peers' => {
  '192.168.240.4' => {
    'type' => 'parent',
    'http-port' => 3128,
    'icp-port' => 4827,
    'options' => [
      'htcp',
      'carp',
      'weight=10',
      'proxy-only'
    ]
  }
}
```

### icp\_access
```ruby
'icp_access' => [
  {
    'action' => 'allow',
    'acls' => ['localnet]
  }
]
```

### htcp\_access
```ruby
'htcp_access' => [
  {
    'action' => 'allow',
    'acls' => ['localnet]
  }
]
```

LDAP Databags
-------------

The following two data bags are only required if you are using LDAP Authentication.

### squid\_hosts - ldap\_auth item
```javascript
{
  "type": "proxy_auth",
  "id": "ldap_auth",
  "net": [
    "REQUIRED"
  ]
}
```

### squid\_acls - ldap\_auth item
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

License & Authors
-----------------
- Author:: Matt Ray (<matt@chef.io>)
- Author:: Sean OMeara (<someara@chef.io>)
- Author:: Alexey Mochkin (<alukardd@alukardd.org>)

```text
Copyright 2012-2015 Chef Software, Inc.

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
