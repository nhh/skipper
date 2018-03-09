class Config
  require 'uri'

  require_relative 'template'
  require_relative '../modules/dns'
  attr_accessor :resolves_to
  attr_accessor :key

  def initialize(key, config)
    @config = config
    @key = key
    @resolves_to = Dns.lookup(service.host)
  rescue StandardError
    exit 255
  end

  # Application service to be proxied
  def service
    URI.parse(@config.split('<')[0].split('->')[1])
  end

  # Domain nginx should listen on
  def domain
    URI.parse(@config.split('<')[0].split('->')[0])
  end

  def template
    @config.split('<')[1]
  end

  def reload_dns_entries
    @resolves_to = Dns.lookup(service.host)
  end
end
