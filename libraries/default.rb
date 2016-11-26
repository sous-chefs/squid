module Opscode
  module Squid
    # helper methods for use in squid recipe code
    module Helpers
      def squid_version
        case node['platform_family']
        when 'debian'
          if node['platform'] == 'ubuntu'
            return '3.1' if node['platform_version'] == '12.04'
            return '3.3' if node['platform_version'] == '14.04'
            return '3.5' if node['platform_version'] == '16.04'
          else
            return '3.1' if node['platform_version'].to_i == 7
            return '3.1' if node['platform_version'].to_i == 12
            return '3.1' if node['platform_version'].to_i == 14
            return '3.4' if node['platform_version'].to_i == 8
            return '3.5' if node['platform_version'].to_i == 16
          end
        when 'rhel'
          return '2.6' if node['platform_version'].to_i == 5
          return '3.1' if node['platform_version'].to_i == 6
          return '3.3' if node['platform_version'].to_i == 7
        when 'fedora'
          return '3.5'
        when 'freebsd'
          return '3.5'
        end
      end

      # load them databags.
      def squid_load_host_acl(databag_name)
        host_acl = []
        begin
          data_bag(databag_name).each do |bag|
            group = data_bag_item(databag_name, bag)
            next unless group['net'].respond_to?(:each)
            group['net'].each do |host|
              host_acl.push [group['id'], group['type'], host]
            end
          end
        rescue
          Chef::Log.info "no '#{databag_name}' data bag"
        end
        host_acl
      end

      def squid_load_url_acl(databag_name)
        url_acl = []
        begin
          data_bag(databag_name).each do |bag|
            group = data_bag_item(databag_name, bag)
            next unless group['urls'].respond_to?(:each)
            group['urls'].each do |url|
              url_acl.push [group['id'], group.key?('element') ? group['element'] : node['squid']['acl_element'], url]
            end
          end
        rescue
          Chef::Log.info "no '#{databag_name}' data bag"
        end
        url_acl
      end

      def squid_load_acls(databag_name)
        acls = []
        begin
          data_bag(databag_name).each do |bag|
            group = data_bag_item(databag_name, bag)
            next unless group['acl'].respond_to?(:each)
            group['acl'].each do |acl|
              acls.push [acl[1], group['id'], acl[0]]
            end
          end
        rescue
          Chef::Log.info "no '#{databag_name}' data bag"
        end
        acls
      end
    end
  end
end
