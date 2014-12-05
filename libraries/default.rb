# load them databags.
def squid_load_host_acl(databag_name)
  host_acl = []
  begin
    data_bag(databag_name).each do |bag|
      group = data_bag_item(databag_name, bag)
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
      group['acl'].each do |acl|
        acls.push [acl[1], group['id'], acl[0]]
      end
    end
  rescue
    Chef::Log.info "no '#{databag_name}' data bag"
  end
  acls
end
