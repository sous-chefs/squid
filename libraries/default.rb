# load them databags.
def squid_load_host_acl
  host_acl = []
  begin
    data_bag("squid_hosts").each do |bag|
      group = data_bag_item("squid_hosts",bag)
      group['net'].each do |host|
        host_acl.push [group['id'],group['type'],host]
      end
    end
  rescue
    Chef::Log.info "no 'squid_hosts' data bag"
  end
  host_acl
end

def squid_load_url_acl
  url_acl = []
  begin
    data_bag("squid_urls").each do |bag|
      group = data_bag_item("squid_urls",bag)
      group['urls'].each do |url|
        url_acl.push [group['id'],url]
      end
    end
  rescue
    Chef::Log.info "no 'squid_urls' data bag"
  end
  url_acl
end

def squid_load_acls
  acls = []
  begin
    data_bag("squid_acls").each do |bag|
      group = data_bag_item("squid_acls",bag)
      group['acl'].each do |acl|
        acls.push [acl[1],group['id'],acl[0]]
      end
    end
  rescue
    Chef::Log.info "no 'squid_acls' data bag"
  end
  acls   
end
