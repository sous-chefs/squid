#
# Author:: Matt Ray <someara@opscode.com>
# Author:: Sean OMeara <someara@opscode.com>
# Cookbook Name:: squid
# Recipe:: default
#
# Copyright 2013, Opscode, Inc
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
port = node['squid']['port']
listen_interface = node['squid']['listen_interface']
if node['squid']['http_binds'].nil?
  http_binds = []
else
  http_binds = node['squid']['http_binds'].is_a?(Array) ? node['squid']['http_binds'].clone : [node['squid']['http_binds']]
end
ipaddress = nil

# determine binds if needed
if http_binds.empty?
  if listen_interface.nil?
    # listen on all interfaces
    http_binds.push(port.to_s)
  else
    ipaddress = node['network']['interfaces'][listen_interface]['addresses'].select { |address, data| data['family'] == 'inet' }.keys[0]
    http_binds.push(ipaddress + ':' + port.to_s)
  end
end
version = node['squid']['version']

# squid/libraries/default.rb
acls = squid_load_acls node['squid']['acls_data_bag_name']
host_acl = squid_load_host_acl node['squid']['hosts_data_bag_name']
url_acl = squid_load_url_acl node['squid']['urls_data_bag_name']

# Log variables to Chef::Log::debug()
if not listen_interface.nil?
  Chef::Log.debug("Squid listen_interface: #{listen_interface}")
  Chef::Log.debug("Squid ipaddress: #{ipaddress}")
end
Chef::Log.debug("Squid http_port binds: " + http_binds.join(', '))
Chef::Log.debug("Squid version: #{version}")
Chef::Log.debug("Squid host_acls: #{host_acl}")
Chef::Log.debug("Squid url_acls: #{url_acl}")
Chef::Log.debug("Squid acls: #{acls}")

# packages
package node['squid']['package']

# rhel_family sysconfig
if platform_family?("rhel")
  template "/etc/sysconfig/squid" do
    source "redhat/sysconfig/squid.erb"
    notifies :restart, "service[#{node['squid']['service_name']}]", :delayed
    mode 00644
  end
end

# squid config dir
directory node['squid']['config_dir'] do
  action :create
  recursive true
  owner "root"
  mode 00755
end

# squid mime config
cookbook_file "#{node['squid']['config_dir']}/mime.conf" do
  source "mime.conf"
  mode 00644
end

# TODO:  COOK-3041 (manage this file appropriately)
file "#{node['squid']['config_dir']}/msntauth.conf" do
  action :delete
end

# squid config
template node['squid']['config_file'] do
  source "squid.conf.erb"
  notifies :reload, "service[#{node['squid']['service_name']}]"
  mode 00644
  variables(
    :http_binds => http_binds,
    :host_acl => host_acl,
    :url_acl => url_acl,
    :acls => acls
    )
end

# services
service node['squid']['service_name'] do
  supports :restart => true, :status => true, :reload => true
  provider Chef::Provider::Service::Upstart if platform?('ubuntu')
  action [ :enable, :start ]
end
