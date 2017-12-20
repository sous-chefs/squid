describe 'Squid server' do
  it 'is listening on port 3128' do
    expect(port(3128)).to be_listening
  end
end

squid_syntax_check = 'sudo squid -k parse'
if os[:family] == 'debian'
  squid_syntax_check = 'sudo squid3 -k parse'
end

describe command(squid_syntax_check) do
  its('exit_status') { should eq 0 }
  its('stderr') { should_not match /WARNING/ }
end
