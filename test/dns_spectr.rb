require 'spectr'
require_relative '../modules/dns'

Spectr.new.test 'Test the dns module' do |test|
  lookup = Dns.lookup 'localhost'

  test.assume('The lookup returns a array', true) do
    lookup.is_a? Array
  end

  test.assume('The ip address for localhost is 127.0.0.1', true) do
    lookup.any? { |ip| ip == '127.0.0.1' || ip == '::1' }
  end
end
