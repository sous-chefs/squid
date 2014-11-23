name             'squid'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@getchef.com'
license          'Apache 2.0'
description      'Installs/configures squid as a simple caching proxy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.2'

%w{debian ubuntu centos fedora redhat scientific suse amazon}.each do |os|
  supports os
end

recipe 'squid', 'Installs and configures Squid.'

