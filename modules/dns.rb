module AutoDNS
  require 'resolv'
  require 'set'

  def self.lookup(hostname)
    Resolv.new.getaddresses(hostname)
  rescue StandardError
    puts 'ERROR! Service is not reachable!'
  end
end
