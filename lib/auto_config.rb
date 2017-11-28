class AutoConfig
  require 'uri'

  require_relative 'auto_template'
  require_relative '../modules/auto_dns'

  attr_accessor :template
  attr_accessor :service
  attr_accessor :domain
  attr_accessor :resolves_to
  attr_accessor :key

  def initialize(key, config)
    @config = config
    @key = key
    @resolves_to = AutoDNS.lookup(service.host)
  rescue StandardError
    exit 255
  end

  def service
    URI.parse(@config.split('<')[0].split('->')[1])
  end

  def domain
    URI.parse(@config.split('<')[0].split('->')[0])
  end

  def template_file
    @config.split('<')[1]
  end
end
