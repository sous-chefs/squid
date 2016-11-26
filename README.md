# squid Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/squid.svg?branch=master)](https://travis-ci.org/chef-cookbooks/squid) [![Cookbook Version](https://img.shields.io/cookbook/v/squid.svg)](https://supermarket.chef.io/cookbooks/squid)

Installs and configures Squid as a caching proxy.

## Requirements

### Platforms

- Debian 7+
- Ubuntu 12.04+
- RHEL/CentOS/Scientific 6+
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

### Squid as a transparent proxy

#### Generating certificates
```
certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --outfile myCA.pem
```

To get the content in a form that chef will accept in it's databags run the following:

```
chef exec ruby -e 'p ARGF.read' myCA.pem
```

#### Configuring cookbook
```node['squid']['enable_ssl_bump'] = true```

Create a databag named ```squid_ssl```

The content of this databag should look like:

```javascript
{
  "id": "proxy",
  "content": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCzs54vZK7GjgOI\noPEGsGVeeSSR3m1JKIKjSZcPiH/CqOJF2PorLRI78lY0GsT4iO+HTc8PEKDGfmA0\ntztT8Vfimc17o5UxEzOknPUbrrG5kHlf5bzZRF22B3qdkeZ/+0Yno0gqXWaDf5qA\nK9pXuWODz0Ft+PYkppTIVIaQRd45T+WnvWb4VXO3nKge0X+RWtGXwoEzHBjO5ViK\nV2x2E4AQMMesa/kxcGIeGsJ1nPQWmoi/sxk/bAgf6Rcc7OzTlXSFn4g53CFnGRJE\nQEHWma29QLJPeR79EJj351Z+hooTIYQ6pQmqNAzrwqttxhCyouceBb2Wix46N+qp\nksl9gu9zAgMBAAECggEAKJNwLmdfh3ndlmYwxj/iQ7i65y0AJDq/dLtTHrDFmGCl\n5vudUU52BY8so8s/mpbg7v5EuLQaeXdjpcOR49xk6cesvDQtpc0eJhdCySNjAfF7\nVon7YFuthUKfDyE4mMFWD/EwhFBeq2aOrk44mQJFVCfiMEC8432xrqJXWBBOo0Xj\n8zKY17lN0Ud9ppouu7mpNw7ObpTV1s7VbS2MDAi+jk0CrXe91XxX2WGhPezPLG9J\nMxxEtnyReRwOrgNeoUN6rSuTdLqkOqGK39hvyWeqPCp8s+iE6t4oYHHH3A4F8PoY\n7vJ9X8gvST0yFVznPafbhSIiAhKW96a2OZsv5Ymr0QKBgQDpSo2vrHk7JNnMo3xK\n4eL9EmXnrV5w1DZLgHcIZp8hDO7ARzqw8w4A+O7N2QM/DIUmH2ND/The5/WkE9BA\nyI7Vc6owtwFKiJmOJ59TvrQeS+4KLhMpNs8VjqwSqPbIFK3iQj6LxEZoeZQxTEi0\n7b22jdS4eShGip28iCDlI8qBxQKBgQDFMaaq53w3SHQydnUMcrR3ZuEfrKSiNRNi\nf6K2uatW1EeVGwn9UKZPMWTuAs5HcSWVg8+uLtaxhyglzw22yuB+d2YowyN7MZMt\nUBb0W8o7rkY4eMZful6ostskmAvL1mKTqamS/7857MIokhfeTXCJBDV2qoGVUgRM\nXWpkfl5X1wKBgQDeJVYCAJR4U0Dqcor6q1qAbbKICDiz6/+/qZavczj4Od5nTex/\nbxLYrjKH5awHr55ijOTzav7wsKTiFtPpvJD2hOt88+bQ2H6QNP6suh2988O6AeHR\nDxXmizMjma1VHQvvNfFlGgOJnKwWvXNGhlRur2PuPcCyW3CUhHP+fjRpmQKBgDuo\nSMb9n1vORLEbm0+3yBczfboqbehQ7FtpR93GECsFr95RPtVvN9FPnTxQhv2gIoG4\nTfVhYDx3KlM97+U0PXSlRLfiSXK0zdTwnPEyb91cXQwqpcFCTe71pUzN3wu9ATex\nJYc+bijlEtxZTnVHslsRdec/sFJvbLN5s31RqdMjAoGAdH7bsvs0WurflryDB3XD\nq00j5WIcHkZG4+E55QZiNsJKAbtLPACu4D/qCEX5bC/QXMF3Uo/lNfuIKYMLA7kF\n07bZ+egNV5tNViKQ40qHHg4JDgtJz8Y64aBYjacyYEQgPQBlIuOSB4WmBrbmg8m9\nQzZWHNDCarKfqS78V16/eb0=\n-----END PRIVATE KEY-----\n-----BEGIN CERTIFICATE-----\nMIIDVzCCAj+gAwIBAgIJAIj1wumabLf9MA0GCSqGSIb3DQEBCwUAMEIxCzAJBgNV\nBAYTAlhYMRUwEwYDVQQHDAxEZWZhdWx0IENpdHkxHDAaBgNVBAoME0RlZmF1bHQg\nQ29tcGFueSBMdGQwHhcNMTYwOTE5MTMwODMwWhcNMTcwOTE5MTMwODMwWjBCMQsw\nCQYDVQQGEwJYWDEVMBMGA1UEBwwMRGVmYXVsdCBDaXR5MRwwGgYDVQQKDBNEZWZh\ndWx0IENvbXBhbnkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA\ns7OeL2Suxo4DiKDxBrBlXnkkkd5tSSiCo0mXD4h/wqjiRdj6Ky0SO/JWNBrE+Ijv\nh03PDxCgxn5gNLc7U/FX4pnNe6OVMRMzpJz1G66xuZB5X+W82URdtgd6nZHmf/tG\nJ6NIKl1mg3+agCvaV7ljg89Bbfj2JKaUyFSGkEXeOU/lp71m+FVzt5yoHtF/kVrR\nl8KBMxwYzuVYildsdhOAEDDHrGv5MXBiHhrCdZz0FpqIv7MZP2wIH+kXHOzs05V0\nhZ+IOdwhZxkSREBB1pmtvUCyT3ke/RCY9+dWfoaKEyGEOqUJqjQM68KrbcYQsqLn\nHgW9loseOjfqqZLJfYLvcwIDAQABo1AwTjAdBgNVHQ4EFgQUV8MfuOCDKKayxUEI\nbj3waW5tY8wwHwYDVR0jBBgwFoAUV8MfuOCDKKayxUEIbj3waW5tY8wwDAYDVR0T\nBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAOTiWkv6NMjEnIb0ehBtFSaKcmocr\nbouZnnIUThqBHTva1l85KD7CAUUBnWAIccwGreHkp6aGlxIrZStmI0+kP/XSNQgJ\nR08r5DX6CWdu1PtdhiF2pIvJmYvyez1itD9CgQNvxkockAYVgvp5KQEwGP+ugN5V\nlIdjUWn0Xa5kSZr1Vl5EPlRetqATSU/1AFWGu5JZUwkldPdM2jy3ANQZ1D/cR+Tm\nrbY0vkQXI7b9imYcgVKqKNHO5b2V/PSe8bSKLwGqk2QHZnHABWYzcgwcu7patJWu\n+Ev5lsJp01w8WFyaN0IsoWG/ysPIFeFdgQAN4aEG19DIDJnu/0etaWxRHw==\n-----END CERTIFICATE-----\n",
  "whitelist": [
    ".google.com"
  ]
}
```

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
