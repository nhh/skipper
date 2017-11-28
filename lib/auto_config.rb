class AutoConfig
  require 'uri'

  require_relative 'auto_template'
  require_relative '../modules/auto_dns'

  attr_accessor :template_file
  attr_accessor :service
  attr_accessor :domain
  attr_accessor :resolves_to

  def initialize(config)
    @config = config
  rescue StandardError
    exit 255
  end

  def service
    @service = URI.parse(@config.split('<')[0].split('->')[1])
  end

  def domain
    @domain = URI.parse(@config.split('<')[0].split('->')[0])
  end

  def template_file
    @template_file = @config.split('<')[1]
  end

  def resolves_to
    @resolves_to = AutoDNS.lookup(@service.host)
  end
end
