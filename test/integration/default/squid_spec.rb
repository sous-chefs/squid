# wait for squid to be started
sleep 15

describe port(3128) do
  it { should be_listening }
end

# This would be great, but it needs a lot more logic to work properly
# squid_syntax_check = 'sudo squid -k parse'
# squid_syntax_check = 'sudo squid3 -k parse' if os[:family] == 'debian'
#
# describe command(squid_syntax_check) do
#   its('exit_status') { should eq 0 }
#   its('stderr') { should_not match /WARNING/ }
# end
