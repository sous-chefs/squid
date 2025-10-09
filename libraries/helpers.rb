module ChefSquidHelpers
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
          # An exclamation mark can be optionally included in the additional array element to invert the ACL
          acls.push [acl[1], "#{acl[2] || ''}#{group['id']}", acl.first]
        end
      end
    rescue
      Chef::Log.info "no '#{databag_name}' data bag"
    end
    acls
  end

  def squid_version_detected
    command = %(#{node['squid']['package']} -v | grep Version | sed 's/.*Version \\\(.\\..\\\).*/\\1/g' | tr -d '\n')
    command_out = shell_out(command)
    command_out.stdout.to_f
  end
end

Chef::Resource.include ChefSquidHelpers
Chef::DSL::Recipe.include ChefSquidHelpers
