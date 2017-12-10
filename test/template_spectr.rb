require 'spectr'
require_relative '../lib/skipper'
require_relative '../lib/config'
require_relative '../lib/template'

Spectr.new.test 'Test the template class' do |test|

  ENV['BALANCE_RULE_TEST'] = 'http://localhost:8080->http://web<example.conf.erb'
  config = Config.new('BALANCE_RULE_TEST', ENV['BALANCE_RULE_TEST'])

  template = Template.new(config)

  test.assume('The template is not nil', false) do
    template.nil?
  end

  test.assume('The template inherits from Template', true) do
    template.is_a?(Template)
  end

  test.assume('The templates content is a String', true) do
    template.content.is_a?(String)
  end

  test.assume('The templates config content upstream', true) do
    template.content.include?('upstream')
  end

  test.assume('The template config name is localhost_8080_web.conf', 'localhost_8080_web.conf') do
    template.config_name
  end

end
