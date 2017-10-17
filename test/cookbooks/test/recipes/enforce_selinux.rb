# Enforce SELinux
execute 'setenforce 1' do
  not_if '[[ $(getenforce) == "Enforcing" ]]'
end

include_recipe 'squid::default'

delete_resource(:execute, 'nitialize squid cache dir')
