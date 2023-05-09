#
# Cookbook:: squid
# Recipe:: default
#
# Copyright:: 2013-2017, Chef Software, Inc
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

# squid/libraries/default.rb
acls = squid_load_acls(node['squid']['acls_databag_name'])
host_acl = squid_load_host_acl(node['squid']['hosts_databag_name'])
url_acl = squid_load_url_acl(node['squid']['urls_databag_name'])

# Log variables to Chef::Log::debug()
Chef::Log.debug("Squid host_acls: #{host_acl}")
Chef::Log.debug("Squid url_acls: #{url_acl}")
Chef::Log.debug("Squid acls: #{acls}")

# packages
package node['squid']['package']

# rhel_family sysconfig
template '/etc/sysconfig/squid' do
  source 'redhat/sysconfig/squid.erb'
  notifies :restart, 'service[squid]', :delayed
  mode '644'
  only_if { platform_family? 'rhel', 'fedora', 'amazon' }
end

# squid config dir
directory node['squid']['config_dir'] do
  action :create
  recursive true
  owner 'root'
  mode '755'
end

# only create directories if config_include_dir attribute is not nil
unless node['squid']['config_include_dir'].nil?

  # squid config include dir
  directory 'squid_config_include_dir' do
    path node['squid']['config_include_dir']
    action :create
    recursive true
    owner 'root'
    mode '755'
  end

  # squid dummy include
  # required, otherwise Squid will not start due to missing .conf files
  file 'squid_config_include_dir_dummy.conf' do
    path "#{node['squid']['config_include_dir']}/dummy.conf"
    content '# Dummy conf to enable Squid includes in conf.d'
  end
end

# squid mime config
cookbook_file "#{node['squid']['config_dir']}/mime.conf" do
  source 'mime.conf'
  mode '644'
end

file "#{node['squid']['config_dir']}/msntauth.conf" do
  action :delete
end

# squid config
template node['squid']['config_file'] do
  source 'squid.conf.erb'
  notifies :reload, 'service[squid]'
  mode '644'
  variables(
    lazy do
      {
        host_acl: host_acl,
        url_acl: url_acl,
        acls: acls,
        directives: node['squid']['directives'],
        localnets: node['squid']['localnets'],
        log_module: node['squid']['log_module'],
        safe_ports: node['squid']['safe_ports'],
        ssl_ports: node['squid']['ssl_ports'],
        version: squid_version_detected,
      }
    end
  )
end

# squid swap dirs
execute 'initialize squid cache dir' do
  command "#{node['squid']['package']} -Nz"
  action :run
  creates ::File.join(node['squid']['cache_dir'], '00')
  notifies :stop, 'service[squid]', :before
  notifies :start, 'service[squid]'
  not_if { FileTest.directory?("#{node['squid']['cache_dir']}/00") }
  only_if { node['squid']['enable_cache_dir'] }
end

# services
service 'squid' do
  supports restart: true, status: true, reload: true
  action [:enable, :start]
  retries 5
end
