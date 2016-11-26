describe 'Squid server' do
  it 'is listening on port 3128' do
    expect(port(3128)).to be_listening
  end
end
