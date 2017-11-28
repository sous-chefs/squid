#
# Cookbook:: squid
# Attributes:: default
#
# Copyright:: 2012-2017, Chef Software, Inc
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
default['squid']['max_file_descriptors'] = nil # Only supported for redhat platforms

default['squid']['acls_databag_name'] = 'squid_acls'
default['squid']['hosts_databag_name'] = 'squid_hosts'
default['squid']['urls_databag_name'] = 'squid_urls'

default['squid']['package'] = 'squid'
default['squid']['config_dir'] = '/etc/squid'
default['squid']['config_include_dir'] = nil   # '/etc/squid/conf.d'
default['squid']['config_file'] = '/etc/squid/squid.conf'
default['squid']['log_dir'] = '/var/log/squid'
default['squid']['log_module'] = nil # e.g. syslog, stdio, or none (nil != none)
default['squid']['cache_dir'] = '/var/spool/squid'
default['squid']['coredump_dir'] = '/var/spool/squid'
default['squid']['acl_element'] = 'url_regex'

default['squid']['localnets'] = ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16', 'fc00::/7', 'fe80::/10']
default['squid']['ssl_ports'] = [443, 563, 873]
default['squid']['safe_ports'] = [80, 21, 443, 70, 210, '1025-65535', 280, 488, 591, 777, 631, 873, 901]
default['squid']['http_access_deny_all'] = true
default['squid']['icp_access_deny_all'] = true

default['squid']['ipaddress'] = node['ipaddress']
default['squid']['listen_interface'] = node['network']['interfaces'].dup.reject { |k, v| k == 'lo' || v[:state] == 'down' }.keys.first
default['squid']['cache_mem'] = '2048'
default['squid']['cache_size'] = '100'
default['squid']['max_obj_size'] = 1024
default['squid']['max_obj_size_unit'] = 'MB'
default['squid']['enable_cache_dir'] = true
default['squid']['logformats'] = {}
default['squid']['access_log_option'] = 'squid'

default['squid']['enable_ldap']       = false
default['squid']['ldap_host']         = nil   # 'ldap.here.com'
default['squid']['ldap_basedn']       = nil   # 'dc=here,dc=com'
default['squid']['ldap_binddn']       = nil   # 'uid=some-user,ou=People,dc=here,dc=com'
default['squid']['ldap_bindpassword'] = nil   # 'some_password'
default['squid']['ldap_searchfilter'] = nil   # 'uid=%s'
default['squid']['ldap_version']      = 3     # LDAP v. 2 or 3
default['squid']['ldap_program']      = '/usr/lib/squid3/basic_ldap_auth' # Default set for Ubuntu 14
default['squid']['ldap_authchildren'] = 5 # Number of LDAP threads to start
default['squid']['ldap_authrealm']    = 'Web-Proxy' # Authentication Realm
default['squid']['ldap_authcredentialsttl'] = '1 minute' # Credentials TTL

case node['platform_family']

when 'debian'
  if node['platform_version'] =~ /^8|^14/
    default['squid']['package'] = 'squid3'
    default['squid']['config_dir'] = '/etc/squid3'
    default['squid']['config_file'] = '/etc/squid3/squid.conf'
    default['squid']['log_dir'] = '/var/log/squid3'
    default['squid']['cache_dir'] = '/var/spool/squid3'
    default['squid']['coredump_dir'] = '/var/spool/squid3'
  else
    default['squid']['package'] = 'squid'
    default['squid']['config_dir'] = '/etc/squid'
    default['squid']['config_file'] = '/etc/squid/squid.conf'
    default['squid']['log_dir'] = '/var/log/squid'
    default['squid']['cache_dir'] = '/var/spool/squid'
    default['squid']['coredump_dir'] = '/var/spool/squid'
  end

when 'smartos'
  default['squid']['listen_interface'] = 'net0'

when 'freebsd'
  default['squid']['config_dir'] = '/usr/local/etc/squid'
  default['squid']['config_file'] = '/usr/local/etc/squid/squid.conf'
  default['squid']['cache_dir'] = '/var/squid/cache'
  default['squid']['coredump_dir'] = '/var/squid/cache'
end
