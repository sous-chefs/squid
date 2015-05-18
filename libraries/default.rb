# load acl and permissions from databags items

def squid_load_acls(databag_name)
  acls = []
  begin
    data_bag(databag_name).each do |bag|
      acl = data_bag_item(databag_name, bag)
      acl['values'].each do |value|
        acls.push [acl['id'], acl['type'], value]
      end
    end
  rescue
    Chef::Log.info "Data bag '#{databag_name}' not found"
  end
  acls
end

def squid_load_permissions(databag_name)
  permissions = []
  begin
    data_bag(databag_name).each do |bag|
      perm = data_bag_item(databag_name, bag)
      permissions.push [perm['action'], "#{perm['acls'].uniq.flatten.join(" ")}"]
    end
  rescue
    Chef::Log.info "no '#{databag_name}' data bag"
  end
  permissions
end
