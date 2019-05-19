require 'spec_helper'

describe 'squid::default on Ubuntu 16.04' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do
    end.converge('squid::default')
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

describe 'squid::default on CentOS 6' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.9') do
    end.converge('squid::default')
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
end

describe 'squid::default with squid_acl databag entries set on CentOS 6' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.8') do
    end.converge('squid::default')
  end

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
