module AutoScheduler
  def self.reload_nginx
    system 'nginx -s reload'
  rescue SystemCallError
    puts "ERROR ====> Can't reload configuration!"
  end

  def self.validate_configuration
    system 'nginx -t'
  rescue SystemCallError
    puts "ERROR ====> Can't apply configuration, please check your template!"
  end
end
