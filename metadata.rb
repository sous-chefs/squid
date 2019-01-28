name              'squid'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs/configures squid as a simple caching proxy'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version      '>= 13'
source_url        'https://github.com/sous-chefs/squid'
issues_url        'https://github.com/sous-chefs/squid/issues'
version           '4.1.0'

%w(debian ubuntu centos redhat scientific suse amazon freebsd).each do |os|
  supports os
end
