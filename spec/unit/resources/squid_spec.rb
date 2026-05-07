# frozen_string_literal: true

require 'spec_helper'

describe 'squid' do
  step_into :squid

  before do
    stub_data_bag('squid_acls').and_return([])
    stub_data_bag('squid_hosts').and_return([])
    stub_data_bag('squid_urls').and_return([])
  end

  context 'with default properties on Ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      squid 'default' do
        detected_version 5.9
      end
    end

    it { is_expected.to install_package('squid') }
    it { is_expected.to create_directory('/etc/squid').with(owner: 'root', mode: '0755') }
    it { is_expected.to create_cookbook_file('/etc/squid/mime.conf').with(source: 'mime.conf', mode: '0644') }
    it { is_expected.to delete_file('/etc/squid/msntauth.conf') }
    it { is_expected.to create_template('/etc/squid/squid.conf').with(mode: '0644') }
    it { is_expected.to enable_service('squid') }
    it { is_expected.to start_service('squid') }
    it { is_expected.to run_execute('initialize squid cache dir').with(command: 'squid -Nz') }

    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('http_access deny all') }
    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('icp_access deny all') }
    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('http_port 3128') }
    it { is_expected.not_to render_file('/etc/squid/squid.conf').with_content('Include additional configuration files') }
    it { is_expected.not_to create_file('/etc/squid/conf.d/dummy.conf') }
  end

  context 'with include directory and inline ACLs' do
    platform 'ubuntu', '24.04'

    recipe do
      squid 'default' do
        detected_version 5.9
        config_include_dir '/etc/squid/conf.d'
        host_acls [['bastion', 'src', '192.168.0.2/32']]
        url_acls [['yubikey', 'url_regex', '^https://api.yubico.com/wsapi/2.0/verify']]
        acls [%w(allow bastion yubikey)]
      end
    end

    it { is_expected.to create_directory('/etc/squid/conf.d').with(owner: 'root', mode: '0755') }
    it { is_expected.to create_file('/etc/squid/conf.d/dummy.conf') }
    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('include /etc/squid/conf.d/*.conf') }
    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('acl bastion src 192.168.0.2/32') }
    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('http_access allow bastion yubikey') }
  end

  context 'with ACL data bags' do
    platform 'ubuntu', '24.04'

    before do
      stub_data_bag('squid_acls').and_return(['my-acl'])
      stub_data_bag_item('squid_acls', 'my-acl').and_return(
        'id' => 'my-acl',
        'acl' => [['', 'allow'], ['', 'deny', '!']]
      )
    end

    recipe do
      squid 'default' do
        detected_version 5.9
      end
    end

    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('http_access allow my-acl') }
    it { is_expected.to render_file('/etc/squid/squid.conf').with_content('http_access deny !my-acl') }
  end

  context 'on AlmaLinux 9' do
    platform 'almalinux', '9'

    recipe do
      squid 'default' do
        detected_version 5.9
        opts '-f /etc/squid/squid.conf'
        max_file_descriptors 4096
      end
    end

    it { is_expected.to create_template('/etc/sysconfig/squid') }
    it { is_expected.to render_file('/etc/sysconfig/squid').with_content('SQUID_OPTS="-f /etc/squid/squid.conf"') }
    it { is_expected.to render_file('/etc/sysconfig/squid').with_content('ulimit -n 4096') }
  end

  context 'action :remove' do
    platform 'ubuntu', '24.04'

    recipe do
      squid 'default' do
        detected_version 5.9
        config_include_dir '/etc/squid/conf.d'
        action :remove
      end
    end

    it { is_expected.to stop_service('squid') }
    it { is_expected.to disable_service('squid') }
    it { is_expected.to delete_file('/etc/squid/squid.conf') }
    it { is_expected.to delete_file('/etc/squid/mime.conf') }
    it { is_expected.to delete_file('/etc/squid/conf.d/dummy.conf') }
    it { is_expected.to delete_directory('/etc/squid/conf.d') }
    it { is_expected.to remove_package('squid') }
  end
end
