# load them databags.
def squid_load_host_acl data_bag_name
  host_acl = []
  begin
    data_bag(data_bag_name).each do |bag|
      group = data_bag_item(data_bag_name, bag)
      group['net'].each do |host|
        host_acl.push [group['id'],group['type'],host]
      end
    end
  rescue
    Chef::Log.info "no such data bag [" + data_bag_name + "]"
  end
  host_acl
end

def squid_load_url_acl data_bag_name
  url_acl = []
  begin
    data_bag(data_bag_name).each do |bag|
      group = data_bag_item(data_bag_name, bag)
      group['urls'].each do |url|
        url_acl.push [group['id'],url]
      end
    end
  rescue
    Chef::Log.info "no such data bag [" + data_bag_name + "]"
  end
  url_acl
end

def squid_load_acls data_bag_name
  acls = []
  begin
    data_bag(data_bag_name).each do |bag|
      group = data_bag_item(data_bag_name, bag)
      group['acl'].each do |acl|
        acls.push [acl[1],group['id'],acl[0]]
      end
    end
  rescue
    Chef::Log.info "no such data bag [" + data_bag_name + "]"
  end
  acls
end
