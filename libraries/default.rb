# load them databags.
def squid_load_host_acl
  host_acl = []
  begin
    data_bag(node['squid']['hosts_data_bag_name']).each do |bag|
      group = data_bag_item(node['squid']['hosts_data_bag_name'], bag)
      group['net'].each do |host|
        host_acl.push [group['id'], group['type'], host]
      end
    end
  rescue
     Chef::Log.info "no '" + node['squid']['hosts_data_bag_name'] + "' data bag"
  end
  host_acl
end

def squid_load_url_acl
  url_acl = []
  begin
    data_bag(node['squid']['urls_data_bag_name']).each do |bag|
      group = data_bag_item(node['squid']['urls_data_bag_name'], bag)
      group['urls'].each do |url|
        url_acl.push [group['id'], group.has_key?('element') ? group['element'] : node['squid']['acl_element'], url]
      end
    end
  rescue
    Chef::Log.info "no '" + node['squid']['urls_data_bag_name'] + "' data bag"
  end
  url_acl
end

def squid_load_acls
  acls = []
  begin
    data_bag(node['squid']['acls_data_bag_name']).each do |bag|
      group = data_bag_item(node['squid']['acls_data_bag_name'], bag)
      group['acl'].each do |acl|
        acls.push [acl[1], group['id'], acl[0]]
      end
    end
  rescue
    Chef::Log.info "no '" + node['squid']['acls_data_bag_name'] + "' data bag"
  end
  acls
end
