class AutoPilot
  $stdout.sync = true
  require 'uri'
  require 'time'

  require_relative '../modules/auto_dns'
  require_relative '../modules/auto_scheduler'

  require_relative 'auto_config'
  require_relative 'auto_template'

  def initialize
    @configurations = []

    ENV.each do |key, config|
      if key.start_with? 'BALANCE_RULE'
        log("Loading #{key} conf", :INFO)
        create_configuration(key, config)
      end
    end
    event_loop
  end

  private

  def event_loop
    loop do
      check_config
      sleep ENV.fetch('INTERVAL', 60)
    end
  end

  def create_configuration(key, config)
    auto_config = AutoConfig.new(key, config)
    @configurations << auto_config
    auto_template = AutoTemplate.new(auto_config)
    auto_template.write_config
    apply_configuration
  end

  def update_configuration(config)
    log("#{config.key} Applying #{config.resolves_to.count} hosts!", :INFO)
    AutoTemplate.new(config).write_config
    apply_configuration
  end

  def apply_configuration
    AutoScheduler.validate_configuration
    AutoScheduler.reload_nginx
  rescue SystemCallError
    log('Your configuration file is not valid!', :CRITICAL)
  end

  def check_config
    @configurations.map! do |config|
      log("#{config.key} Checking for updates...", :INFO)
      if config.resolves_to.count != new_entries(config).count
        config.reload_dns_entries
        update_configuration(config)
      elsif (config.resolves_to - new_entries(config)).count.zero?
        log('No changes detected, skipping.', :INFO)
      end
      config
    end
  end

  def log(message, errorlevel = :INFO)
    puts "#{Date.today} #{errorlevel.to_s.upcase}: #{message}"
  end

  def new_entries(config)
    AutoDNS.lookup(config.service.host)
  end
end

AutoPilot.new
