# wait for squid to be started
sleep 15

describe port(3128) do
  it { should be_listening }
end

squid_syntax_check = 'sudo squid -k parse'
if os[:family] == 'debian'
  squid_syntax_check = 'sudo squid3 -k parse'
end

describe command(squid_syntax_check) do
  its('exit_status') { should eq 0 }
  its('stderr') { should_not match /WARNING/ }
end
