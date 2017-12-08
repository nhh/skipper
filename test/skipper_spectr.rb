require 'spectr'
require_relative '../lib/skipper'
require_relative '../lib/config'

Spectr.new.test 'Test the initialization of the skipper class' do |test|

  skipper = Skipper.new

  test.assume('the skipper class exists', true) do
    skipper.is_a?(Skipper)
  end

  test.assume('the skipper class is not nil', false) do
    skipper.nil?
  end

end

Spectr.new.test 'Test the env handling' do |test|

  skipper = Skipper.new

  ENV['BALANCE_RULE_TEST'] = 'http://localhost:8080->http://web<example.conf.erb'

  skipper.load_env_variables

  test.assume('configuration array is not null', false) do
    skipper.configurations.count.zero?
  end

  test.assume('configuration array holds exactly one object', 1) do
    skipper.configurations.count
  end

  test.assume('the first in configuration array is Config', true) do
    skipper.configurations[0].is_a?(Config)
  end

end