node.default['squid']['cache_size'] = 10
node.default['squid']['cache_mem'] = 10

apt_update

# Enforce SELinux
if platform_family?('rhel', 'amazon', 'fedora')
  execute 'setenforce 1' do
    not_if '[[ $(getenforce) == "Enforcing" ]]'
  end
end

include_recipe 'squid::default'
