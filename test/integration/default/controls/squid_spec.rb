# frozen_string_literal: true

# wait for squid to be started
sleep 15

describe port(3128) do
  it { should be_listening }
end

describe directory('/var/spool/squid/00') do
  it { should exist }
end
