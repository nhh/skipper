require 'spectr'
require_relative '../lib/config'
require 'uri'

Spectr.new.test 'The configuration class' do |test|
  ENV['BALANCE_RULE_TEST'] = 'http://localhost:8080->http://web<example.conf.erb'

  config = Config.new('BALANCE_RULE_TEST', ENV['BALANCE_RULE_TEST'])

  test.assume('The candidate is initialized correctly', true) do
    config.is_a?(Config)
  end

  test.assume('The config key is balance_rule_test', 'BALANCE_RULE_TEST') do
    config.key
  end

  test.assume('The config resolves_to is a Array', true) do
    config.resolves_to.is_a?(Array)
  end

  test.assume('The config service is a URI', true) do
    config.service.is_a?(URI)
  end

  test.assume('The config service host is web', 'web') do
    config.service.host
  end

  test.assume('The config template is example.conf.erb', 'example.conf.erb') do
    config.template
  end
end
