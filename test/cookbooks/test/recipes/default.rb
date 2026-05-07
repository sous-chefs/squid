# frozen_string_literal: true

apt_update

# Enforce SELinux
if platform_family?('rhel', 'amazon', 'fedora')
  execute 'setenforce 1' do
    only_if '[[ $(getenforce) == "Enforcing" ]]'
  end
end

squid 'default' do
  cache_size 10
  cache_mem 10
end
