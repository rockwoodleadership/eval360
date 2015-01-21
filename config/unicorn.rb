worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 30 
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool']            =   ENV['DB_POOL'] || 2
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    ActiveRecord::Base.establish_connection(config)
end

