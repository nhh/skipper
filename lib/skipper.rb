class Skipper
  $stdout.sync = true
  require 'uri'
  require 'time'

  require_relative '../modules/dns'
  require_relative '../modules/scheduler'

  require_relative 'config'
  require_relative 'template'

  attr_accessor :configurations

  def initialize
    @configurations = []
  end

  def load_env_variables
    ENV.each do |key, config|
      next unless key.start_with? 'BALANCE_RULE'
      log("Loading #{key} conf", :INFO)
      auto_config = Config.new(key, config)
      @configurations << auto_config
    end
  end

  def create_initial_config
    exit 255 if @configurations.empty?
    @configurations.each do |config|
      auto_template = Template.new(config)
      auto_template.write_config
      apply_configuration
    end
  end

  def update_loop
    loop do
      @configurations.map! do |config|
        log("#{config.key} Checking for updates...", :INFO)
        check_config(config)
        config
      end
      sleep ENV.fetch('INTERVAL', 60).to_i
    end
  end

  private

  def update_configuration(config)
    log("#{config.key} Applying #{config.resolves_to.count} hosts!", :INFO)
    Template.new(config).write_config
    apply_configuration
  end

  def apply_configuration
    Scheduler.validate_configuration
    Scheduler.reload_nginx
  rescue SystemCallError
    log('Your configuration file is not valid!', :CRITICAL)
  end

  def check_config(config)
    if config.resolves_to.count != new_entries(config).count
      config.reload_dns_entries
      update_configuration(config)
    elsif (config.resolves_to - new_entries(config)).count.zero?
      log('No changes detected, skipping.', :INFO)
    else
      config.reload_dns_entries
      update_configuration(config)
    end
  end

  def log(message, errorlevel = :INFO)
    puts "#{Date.today} #{errorlevel.to_s.upcase}: #{message}"
  end

  def new_entries(config)
    Dns.lookup(config.service.host)
  end
end
