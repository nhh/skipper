require_relative 'spectre'

Spectre.test_that 'the String class works' do

  candidate = "Hello"

  Spectre.ensure_that 'the candidate is a string' do
    candidate.is_a?(String)
  end

  Spectre.ensure_that 'the candidate has 5 letters' do
    candidate.split('').count == 5
  end

end

Spectre.test_that 'the Integer class works' do

  candidate = 17

  Spectre.ensure_that 'the candidate is a integer' do
    candidate.is_a?(Integer)
  end

  Spectre.ensure_that 'the candidate is 17' do
    candidate.eql? 17
  end

end