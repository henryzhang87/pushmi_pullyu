# require 'pushmi_pullyu/version' must be first as it declares the PushmiPullyu
# module. (This fixes a weird NameError bug when using the nested compact syntax
# for defining modules/classes like `module PushmiPullyu::Logging`)

require 'pushmi_pullyu/version'
require 'pushmi_pullyu/logging'
require 'pushmi_pullyu/aip'
require 'pushmi_pullyu/aip/creator'
require 'pushmi_pullyu/aip/downloader'
require 'pushmi_pullyu/cli'
require 'pushmi_pullyu/preservation_queue'
require 'pushmi_pullyu/swift_depositer'
require 'active_support'
require 'active_support/core_ext'

# PushmiPullyu main module
module PushmiPullyu
  DEFAULTS = {
    aip_version: 'lightaip-2.0',
    daemonize: false,
    debug: false,
    logdir: 'log',
    minimum_age: 0,
    monitor: false,
    piddir: 'tmp/pids',
    workdir: 'tmp/work',
    process_name: 'pushmi_pullyu',
    queue_name: 'dev:pmpy_queue',
    redis: {
      url: 'redis://localhost:6379'
    },
    swift: {
      tenant: 'tester',
      username: 'test:tester',
      password: 'testing',
      auth_url: 'http://localhost:8080/auth/v1.0',
      project_name: 'demo',
      project_domain_name: 'default',
      container: 'ERA'
    },
    rollbar: {
    },
    jupiter: {
      user: ENV['JUPITER_USER'],
      api_key: ENV['JUPITER_API_KEY'],
      jupiter_url: ENV['JUPITER_URL'] || 'http://localhost:3000/',
      aip_api_path: ENV['JUPITER_AIP_API_PATH'] || 'aip/v1'
    }
  }.freeze

  def self.options
    @options ||= DEFAULTS.dup
  end

  def self.options=(opts)
    options.deep_merge!(opts)
  end

  def self.override_options(opts)
    @options = opts
  end

  def self.application_log_file
    "#{options[:logdir]}/#{options[:process_name]}.log"
  end

  def self.logger
    PushmiPullyu::Logging.logger
  end

  def self.logger=(log)
    PushmiPullyu::Logging.logger = log
  end

  def self.server_running=(status)
    @server_running = status
  end

  def self.reset_logger=(status)
    @reset_logger = status
  end

  def self.server_running?
    @server_running
  end

  def self.continue_polling?
    server_running? && !reset_logger?
  end

  def self.reset_logger?
    @reset_logger
  end
end
