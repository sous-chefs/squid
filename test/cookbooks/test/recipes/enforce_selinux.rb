# Enforce SELinux
execute 'setenforce 1' do
  not_if '[[ $(getenforce) == "Enforcing" ]]'
end
