# Migration Guide

This release replaces the `squid::default` recipe and `node['squid']` attributes with the public
`squid` custom resource.

## Before

```ruby
node.default['squid']['cache_size'] = 10
node.default['squid']['cache_mem'] = 10

include_recipe 'squid::default'
```

## After

```ruby
squid 'default' do
  cache_size 10
  cache_mem 10
end
```

## Breaking Changes

* `recipes/` has been removed. Consumers must declare the `squid` resource directly.
* `attributes/` has been removed. Configure Squid with resource properties instead of
  `node['squid']` attributes.
* Data bag defaults remain `squid_acls`, `squid_hosts`, and `squid_urls`; override
  `acls_databag_name`, `hosts_databag_name`, or `urls_databag_name` when needed.
* Inline ACLs may be supplied with `acls`, `host_acls`, and `url_acls` properties.

See `test/cookbooks/test/recipes/default.rb` for the convergence example used by Kitchen.
