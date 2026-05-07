# frozen_string_literal: true

provides :squid
unified_mode true

property :package_name, String, default: 'squid'
property :service_name, String, default: 'squid'
property :config_dir, String, default: lazy { platform_family?('freebsd') ? '/usr/local/etc/squid' : '/etc/squid' }
property :config_include_dir, [String, nil]
property :config_file, String, default: lazy { ::File.join(config_dir, 'squid.conf') }
property :log_dir, String, default: '/var/log/squid'
property :cache_dir, String, default: lazy { platform_family?('freebsd') ? '/var/squid/cache' : '/var/spool/squid' }
property :coredump_dir, String, default: lazy { cache_dir }
property :port, [Integer, String, Array], default: 3128
property :timeout, [Integer, String], default: '10'
property :opts, String, default: ''
property :directives, Array, default: []
property :max_file_descriptors, [Integer, String, nil], default: nil
property :acls_databag_name, String, default: 'squid_acls'
property :hosts_databag_name, String, default: 'squid_hosts'
property :urls_databag_name, String, default: 'squid_urls'
property :acl_element, String, default: 'url_regex'
property :host_acls, Array, default: []
property :url_acls, Array, default: []
property :acls, Array, default: []
property :localnets, Array, default: ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16', 'fc00::/7', 'fe80::/10']
property :ssl_ports, Array, default: [443, 563, 873]
property :safe_ports, Array, default: [80, 21, 443, 70, 210, '1025-65535', 280, 488, 591, 777, 631, 873, 901]
property :enable_safe_ports_restriction, [true, false], default: true
property :enable_connect_restriction, [true, false], default: true
property :http_access_deny_all, [true, false], default: true
property :icp_access_deny_all, [true, false], default: true
property :cache_mem, [Integer, String], default: '2048'
property :cache_size, [Integer, String], default: '100'
property :max_obj_size, [Integer, String], default: 1024
property :max_obj_size_unit, String, default: 'MB'
property :enable_cache_dir, [true, false], default: true
property :logformats, Hash, default: {}
property :access_log_option, String, default: 'squid'
property :log_module, [String, nil]
property :cache_peer, [String, nil]
property :detected_version, [Float, Integer, String, nil]
property :enable_ldap, [true, false], default: false
property :ldap_host, [String, nil]
property :ldap_basedn, [String, nil]
property :ldap_binddn, [String, nil]
property :ldap_bindpassword, [String, nil], sensitive: true
property :ldap_searchfilter, [String, nil]
property :ldap_version, [Integer, String], default: 3
property :ldap_program, String, default: '/usr/lib/squid3/basic_ldap_auth'
property :ldap_authchildren, [Integer, String], default: 5
property :ldap_authrealm, String, default: 'Web-Proxy'
property :ldap_authcredentialsttl, String, default: '1 minute'

default_action :install

action :install do
  package new_resource.package_name

  template '/etc/sysconfig/squid' do
    source 'redhat/sysconfig/squid.erb'
    cookbook 'squid'
    variables(
      opts: new_resource.opts,
      timeout: new_resource.timeout,
      config_file: new_resource.config_file,
      max_file_descriptors: new_resource.max_file_descriptors
    )
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
    mode '0644'
    only_if { platform_family?('rhel', 'fedora', 'amazon') }
  end

  directory new_resource.config_dir do
    recursive true
    owner 'root'
    mode '0755'
  end

  if new_resource.config_include_dir
    directory new_resource.config_include_dir do
      recursive true
      owner 'root'
      mode '0755'
    end

    file "#{new_resource.config_include_dir}/dummy.conf" do
      content '# Dummy conf to enable Squid includes in conf.d'
      mode '0644'
    end
  end

  cookbook_file "#{new_resource.config_dir}/mime.conf" do
    source 'mime.conf'
    cookbook 'squid'
    mode '0644'
  end

  file "#{new_resource.config_dir}/msntauth.conf" do
    action :delete
  end

  service new_resource.service_name do
    supports restart: true, status: true, reload: true
    action [:enable, :start]
    retries 5
  end

  template new_resource.config_file do
    source 'squid.conf.erb'
    cookbook 'squid'
    notifies :reload, "service[#{new_resource.service_name}]"
    mode '0644'
    variables squid_config_variables
  end

  execute 'initialize squid cache dir' do
    command "#{new_resource.package_name} -Nz"
    creates ::File.join(new_resource.cache_dir, '00')
    notifies :stop, "service[#{new_resource.service_name}]", :before
    notifies :start, "service[#{new_resource.service_name}]"
    only_if { new_resource.enable_cache_dir }
  end
end

action :remove do
  service new_resource.service_name do
    supports restart: true, status: true, reload: true
    action [:stop, :disable]
    retries 5
  end

  file new_resource.config_file do
    action :delete
  end

  file "#{new_resource.config_dir}/mime.conf" do
    action :delete
  end

  if new_resource.config_include_dir
    file "#{new_resource.config_include_dir}/dummy.conf" do
      action :delete
    end

    directory new_resource.config_include_dir do
      recursive true
      action :delete
    end
  end

  file '/etc/sysconfig/squid' do
    action :delete
    only_if { platform_family?('rhel', 'fedora', 'amazon') }
  end

  package new_resource.package_name do
    action :remove
  end
end

action_class do
  include SquidCookbook::Helpers

  def squid_config_variables
    loaded_host_acls = new_resource.host_acls + squid_load_host_acl(new_resource.hosts_databag_name)
    loaded_url_acls = new_resource.url_acls + squid_load_url_acl(new_resource.urls_databag_name, new_resource.acl_element)
    loaded_acls = new_resource.acls + squid_load_acls(new_resource.acls_databag_name)

    Chef::Log.debug("Squid host_acls: #{loaded_host_acls}")
    Chef::Log.debug("Squid url_acls: #{loaded_url_acls}")
    Chef::Log.debug("Squid acls: #{loaded_acls}")

    {
      access_log_option: new_resource.access_log_option,
      acls: loaded_acls,
      cache_dir: new_resource.cache_dir,
      cache_mem: new_resource.cache_mem,
      cache_peer: new_resource.cache_peer,
      cache_size: new_resource.cache_size,
      config_include_dir: new_resource.config_include_dir,
      coredump_dir: new_resource.coredump_dir,
      directives: new_resource.directives,
      enable_cache_dir: new_resource.enable_cache_dir,
      enable_connect_restriction: new_resource.enable_connect_restriction,
      enable_ldap: new_resource.enable_ldap,
      enable_safe_ports_restriction: new_resource.enable_safe_ports_restriction,
      host_acl: loaded_host_acls,
      http_access_deny_all: new_resource.http_access_deny_all,
      icp_access_deny_all: new_resource.icp_access_deny_all,
      ldap_authchildren: new_resource.ldap_authchildren,
      ldap_authcredentialsttl: new_resource.ldap_authcredentialsttl,
      ldap_authrealm: new_resource.ldap_authrealm,
      ldap_basedn: new_resource.ldap_basedn,
      ldap_binddn: new_resource.ldap_binddn,
      ldap_bindpassword: new_resource.ldap_bindpassword,
      ldap_host: new_resource.ldap_host,
      ldap_program: new_resource.ldap_program,
      ldap_searchfilter: new_resource.ldap_searchfilter,
      ldap_version: new_resource.ldap_version,
      localnets: new_resource.localnets,
      log_dir: new_resource.log_dir,
      log_module: new_resource.log_module,
      logformats: new_resource.logformats,
      max_obj_size: new_resource.max_obj_size,
      max_obj_size_unit: new_resource.max_obj_size_unit,
      port: new_resource.port,
      safe_ports: new_resource.safe_ports,
      ssl_ports: new_resource.ssl_ports,
      url_acl: loaded_url_acls,
      version: new_resource.detected_version || squid_version_detected(new_resource.package_name),
    }
  end
end
