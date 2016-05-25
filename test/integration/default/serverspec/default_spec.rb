require 'spec_helper'

# firewall rules
expected_rules = [
  %r{ 22/tcp + ALLOW IN +Anywhere},
  %r{ 80,443/tcp + ALLOW IN +Anywhere}
]

# check if firewall is actives
describe command('ufw status numbered') do
  its(:stdout) { should match(/Status: active/) }

  expected_rules.each do |r|
    its(:stdout) { should match(r) }
  end

end

# is the firewall on
describe service('ufw') do
  it { should be_enabled.with_level('S') }
  it { should be_running }
end

# is nginx running
describe service('nginx') do
  it { should be_running }
end

# are we listening on port 80
describe port(80) do
  it { is_expected.to be_listening.on('0.0.0.0').with('tcp') }
end

# are we listening on port 443
describe port(443) do
  it { is_expected.to be_listening.on('0.0.0.0').with('tcp') }
end

describe 'HTTP requests' do
  it 'are redirected to HTTPS' do
    expect(WebRequest.new(url: 'http://127.0.0.1/').response).to be_a(Net::HTTPRedirection)
  end
end

describe 'Webpage content' do
	it 'says Hello World!' do
  	expect(WebRequest.new(url: 'https://127.0.0.1/').response.body).to match(/Hello World!/)
 	end
end