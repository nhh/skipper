class Template
  require 'erb'
  require 'fileutils'

  def initialize(auto_config)
    @config = auto_config
  end

  def write_config
    File.write(target_file, content)
  end

  def content
    template = File.read(File.join(File.dirname(__FILE__), '..', 'templates', @config.template))
    ERB.new(template, nil, '-').result(binding)
  end

  def target_file
    File.join('/etc', '/nginx', '/conf.d', "#{config_name}.conf")
  end

  def config_name
    "#{@config.domain.host}_#{@config.domain.port}_#{@config.service.host}.conf"
  end
end
