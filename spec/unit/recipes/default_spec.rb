require 'spec_helper'

describe 'default recipe on Ubuntu 14.04' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.automatic[:lsb][:codename] = 'trusty'
    end.converge('unicorn::default')
  end

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'squid::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'freebsd', version: '10.0') do
    end.converge(described_recipe)
  end

  it 'creates missing directories' do
    expect(chef_run).to run_execute('squid -Nz').with(
      creates: '/var/squid/cache/00'
    )
  end
end
