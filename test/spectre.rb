require 'coveralls'
Coveralls.wear!

class Spectre

  def test(description)
    @description = description
    SimpleCov.command_name description
    puts "INFO: #{description}"
    yield self
    self
  end

  def assume(assumption, expected_result)
    @assumption = assumption
    @expected_result = expected_result
    begin
      @result = yield
    rescue => e
      @result = e
    end
    compare
    exit 255 if @abort
  end

  def compare
    if @result.eql? @expected_result
      puts "     GREEN: Assume: #{@assumption}"
    else
      @color = 'red'
      puts "     RED: Assume: #{@assumption}"
      puts "          Expected #{@expected_result.inspect} but got #{@result.inspect}"
      @abort = true
    end
  end

end