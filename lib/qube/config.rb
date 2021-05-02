require 'logger'
require 'securerandom'

module Qube
  class << self
    attr_accessor :config
  end

  def self.setup
    self.config ||= Config.new
    yield config
  end

  class Config
    attr_accessor :api_uri
    attr_accessor :api_token
    attr_accessor :timeout
    attr_accessor :user_agent
    attr_accessor :logger
    attr_accessor :logger_level

    def initialize
      @api_uri      = ENV['QUBE_API_URI']   || 'http://localhost:9191/qube/api/v1'
      @api_token    = ENV['QUBE_API_TOKEN'] || '77c04ced3f915240d0c5d8d5819f84c7'   # bash: md5 -s qube
      @timeout      = 2
      @user_agent   = 'QubeRubyClient'
      @logger       = ::Logger.new STDOUT
      @logger.level = @logger_level
      @http_debug   = true
    end
  end
end