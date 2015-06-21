#
# Author:: Matt Ray <matt@chef.io>
# Author:: Sean OMeara <someara@chef.io>
# Cookbook Name:: squid
# Attributes:: default
#
# Copyright 2012-2014, Chef Software, Inc
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

default['squid']['port'] = 3128
default['squid']['network'] = nil
default['squid']['timeout'] = '10'
default['squid']['opts'] = ''
default['squid']['directives'] = []

default['squid']['acls_databag_name'] = 'squid_acls'
default['squid']['hosts_databag_name'] = 'squid_hosts'
default['squid']['urls_databag_name'] = 'squid_urls'

default['squid']['package'] = 'squid'
default['squid']['version'] = '3.1'
default['squid']['config_dir'] = '/etc/squid'
default['squid']['config_file'] = '/etc/squid/squid.conf'
default['squid']['log_dir'] = '/var/log/squid'
default['squid']['cache_dir'] = '/var/spool/squid'
default['squid']['coredump_dir'] = '/var/spool/squid'
default['squid']['service_name'] = 'squid'
default['squid']['acl_element'] = 'url_regex'

default['squid']['ipaddress'] = node['ipaddress']
default['squid']['listen_interface'] = node['network']['interfaces'].dup.reject { |k, _v| k == 'lo' }.keys.first
default['squid']['cache_mem'] = '2048'
default['squid']['cache_size'] = '100'
default['squid']['max_obj_size'] = 1024
default['squid']['max_obj_size_unit'] = 'MB'
default['squid']['enable_cache_dir'] = true

default['squid']['enable_ldap']       = false
default['squid']['ldap_host']         = nil   # 'ldap.here.com'
default['squid']['ldap_basedn']       = nil   # 'dc=here,dc=com'
default['squid']['ldap_binddn']       = nil   # 'uid=some-user,ou=People,dc=here,dc=com'
default['squid']['ldap_bindpassword'] = nil   # 'some_password'
default['squid']['ldap_searchfilter'] = nil   # 'uid=%s'
default['squid']['ldap_version']      = 3     # LDAP v. 2 or 3
default['squid']['ldap_program']      = '/usr/lib/squid3/basic_ldap_auth' # Default set for Ubuntu 14
default['squid']['ldap_authchildren'] = 5     # Number of LDAP threads to start
default['squid']['ldap_authrealm']    = 'Web-Proxy'   # Authentication Realm
default['squid']['ldap_authcredentialsttl'] = '1 minute'  # Credentials TTL

case platform_family

when 'debian'
  case platform
  when 'debian'
    if node['platform_version'] == '6.0.3'
      default['squid']['package'] = 'squid3'
      default['squid']['config_dir'] = '/etc/squid3'
      default['squid']['config_file'] = '/etc/squid3/squid.conf'
      default['squid']['service_name'] = 'squid3'
    end

  when 'ubuntu'
    if node['platform_version'] == '10.04'
      default['squid']['version'] = '2.7'
    elsif node['platform_version'] == '12.04' || node['platform_version'] =~ /1[34]\./
      default['squid']['package'] = 'squid3'
      default['squid']['version'] = '3.1' if node['platform_version'] =~ /13\./
      default['squid']['version'] = '3.3' if node['platform_version'] =~ /14\./
      default['squid']['config_dir'] = '/etc/squid3'
      default['squid']['config_file'] = '/etc/squid3/squid.conf'
      default['squid']['log_dir'] = '/var/log/squid3'
      default['squid']['cache_dir'] = '/var/spool/squid3'
      default['squid']['coredump_dir'] = '/var/spool/squid3'
      default['squid']['service_name'] = 'squid3'
    end
  end

when 'rhel'
  rhel_version = node['platform_version'].to_f
  default['squid']['version'] = '2.6' if rhel_version >= 5 && rhel_version < 6
  default['squid']['version'] = '3.1' if rhel_version >= 6 && rhel_version < 7
  default['squid']['version'] = '3.3' if rhel_version >= 7 && rhel_version < 8

when 'fedora'
  default['squid']['version'] = '3.4'

when 'smartos'
  default['squid']['listen_interface'] = 'net0'
end
