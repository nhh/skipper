require_relative 'spectre'
require_relative '../lib/config'
require 'uri'

Spectre.new.test 'the configuration class' do |test|

  ENV['BALANCE_RULE_TEST'] = 'http://localhost:8080->http://web<example.conf.erb'

  config = Config.new('BALANCE_RULE_TEST', ENV['BALANCE_RULE_TEST'])

  test.assume('the candidate is initialized correctly', true) do
    config.is_a?(Config)
  end

  test.assume('the config key is balance_rule_test', 'BALANCE_RULE_TEST') do
    config.key
  end

  test.assume('the config resolves_to is a Array', true) do
    config.resolves_to.is_a?(Array)
  end

  test.assume('the config service is a URI', true) do
    config.service.is_a?(URI)
  end

  test.assume('the config service host is web', 'web') do
    config.service.host
  end

  test.assume('the config template is example.conf.erb', 'example.conf.erb') do
    config.template
  end

end