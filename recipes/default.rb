#
# Author:: Matt Ray <matt@chef.io>
# Author:: Sean OMeara <someara@chef.io>
# Cookbook Name:: squid
# Recipe:: default
#
# Copyright 2013-2014, Chef Software, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# variables
version = node['squid']['version']

acls = node['squid']['acls']
permissions = []
node['squid']['permissions'].uniq.each do |perm|
  permissions << "#{perm['action']} #{perm['acls'].uniq.flatten.join(" ")}"
end


# Log variables to Chef::Log::debug()
Chef::Log.debug("Squid version: #{version}")
Chef::Log.debug("Squid acls: #{acls}")
Chef::Log.debug("Squid permissions: #{permissions}")

# packages
package node['squid']['package']

# rhel_family sysconfig
template '/etc/sysconfig/squid' do
  source 'redhat/sysconfig/squid.erb'
  notifies :restart, "service[#{node['squid']['service_name']}]", :delayed
  mode 00644
  only_if { platform_family? 'rhel', 'fedora' }
end

# squid config dir
directory node['squid']['config_dir'] do
  action :create
  recursive true
  owner 'root'
  mode 00755
end

# squid mime config
cookbook_file "#{node['squid']['config_dir']}/mime.conf" do
  source 'mime.conf'
  mode 00644
end

# TODO:  COOK-3041 (manage this file appropriately)
file "#{node['squid']['config_dir']}/msntauth.conf" do
  action :delete
end

# squid config
template node['squid']['config_file'] do
  source 'squid.conf.erb'
  notifies :reload, "service[#{node['squid']['service_name']}]"
  mode 00644
  variables(
    #:acls => acls,
    #:permissions => permissions,
    :acls => acls,
    :permissions => permissions,
    :refresh_patterns => node['squid']['refresh_patterns'],
    :directives => node['squid']['directives']
    )
end

# services
service node['squid']['service_name'] do
  supports :restart => true, :status => true, :reload => true
  provider Chef::Provider::Service::Upstart if platform?('ubuntu')
  action [:enable, :start]
end
