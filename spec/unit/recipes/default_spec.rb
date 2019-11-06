require 'spec_helper'

describe 'squid::default' do
  before do
    stubs_for_resource('template[/etc/squid/squid.conf]') do |resource|
      allow(resource).to receive_shell_out("squid -v | grep Version | sed 's/.*Version \\(.\\..\\).*/\\1/g' | tr -d '\n'")
    end
  end

  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
    end

    it 'installs package squid' do
      expect(chef_run).to install_package('squid')
    end

    it 'templates /etc/squid/squid.conf' do
      expect(chef_run).to create_template('/etc/squid/squid.conf')
    end

    it 'templates /etc/squid/squid.conf http deny all' do
      expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
        'http_access deny all'
      )
    end

    it 'templates /etc/squid/squid.conf icp deny all' do
      expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
        'icp_access deny all'
      )
    end

    it 'templates /etc/squid/squid.conf without include directory' do
      expect(chef_run).to_not render_file('/etc/squid/squid.conf').with_content(
        'Include additional configuration files'
      )
    end

    it 'file /etc/squid/conf.d/dummy.conf' do
      expect(chef_run).to_not create_file('/etc/squid/conf.d/dummy.conf')
    end

    it 'directory /etc/squid/conf.d/' do
      expect(chef_run).to_not create_directory('/etc/squid/conf.d')
    end
  end

  context 'When all attributes are default, on an Centos 6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6')
                          .converge(described_recipe)
    end

    it 'installs package squid' do
      expect(chef_run).to install_package('squid')
    end

    it 'templates /etc/sysconfig/squid' do
      expect(chef_run).to create_template('/etc/sysconfig/squid')
    end

    it 'templates /etc/squid/squid.conf' do
      expect(chef_run).to create_template('/etc/squid/squid.conf')
    end

    it 'templates /etc/squid/squid.conf http deny all' do
      expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
        'http_access deny all'
      )
    end

    it 'templates /etc/squid/squid.conf icp deny all' do
      expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
        'icp_access deny all'
      )
    end

    it 'templates /etc/squid/squid.conf without include directory' do
      expect(chef_run).to_not render_file('/etc/squid/squid.conf').with_content(
        'Include additional configuration files'
      )
    end

    it 'file /etc/squid/conf.d/dummy.conf' do
      expect(chef_run).to_not create_file('/etc/squid/conf.d/dummy.conf')
    end

    it 'directory /etc/squid/conf.d/' do
      expect(chef_run).to_not create_directory('/etc/squid/conf.d')
    end

    context 'With squid_acl databag entries' do
      before do
        # Required to make spec pass
        # https://github.com/sethvargo/chefspec/issues/260
        stub_command('/etc/squid/conf.d').and_return(false)
        stub_data_bag('squid_acls').and_return(['my-acl'])
        stub_data_bag_item('squid_acls', 'my-acl').and_return(
          "id": 'my-acl',
          "acl": [['', 'allow'], ['', 'deny', '!']]
        )
      end

      it 'templates /etc/squid/squid.conf with content http_access allow my-acl' do
        expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
          'http_access allow my-acl'
        )
      end

      it 'templates /etc/squid/squid.conf with content http_access deny !my-acl' do
        expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
          'http_access deny !my-acl'
        )
      end
    end
  end
end
