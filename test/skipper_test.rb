require_relative 'spectre'
require_relative '../lib/skipper'

Spectre.new.test 'Test the initialization of the skipper class' do |test|
  skipper = Skipper.new

  test.assume('the skipper class exists', true) do
    skipper.is_a?(Skipper)
  end

  test.assume('the skipper class is not nil', false) do
    skipper.nil?
  end

end

Spectre.new.test 'Test the env handling' do |test|

  skipper = Skipper.new

  ENV['BALANCE_RULE_TEST'] = 'http://localhost:8080->http://web<example.conf.erb'

  skipper.load_env_variables

  test.assume('configuration array is not null', false) do
    skipper.configurations.count.zero?
  end

  test.assume('configuration array holds exactly one object', 1) do
    skipper.configurations.count
  end

end