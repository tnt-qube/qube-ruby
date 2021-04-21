require 'uri'
require 'json'
require 'net/http'
require 'net/http/persistent'

module Qube
  class HTTP

    VERBS = {
      get:    Net::HTTP::Get,
      post:   Net::HTTP::Post,
      put:    Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }

    Response = Struct.new(:code, :body)

    def initialize
      @config     = Qube.config
      @connection = Net::HTTP::Persistent.new

      @api_uri    = @config.api_uri
      @api_token  = @config.api_token
      @user_agent = @config.user_agent
      @logger     = @config.logger
    end

    def base_headers
      {
        'X-Auth-Token' => @api_token,
        'User-Agent'   => @user_agent,
        'Content-Type' => 'application/json'
      }
    end

    def get(path, options = {})
      execute(path, :get, options)
    end

    def post(path, options = {})
      execute(path, :post, options)
    end

    def put(path, options = {})
      execute(path, :put, options)
    end

    def delete(path, options = {})
      execute(path, :delete, options)
    end

    private
      def execute(path, method, options = {})
        url = URI.join(@api_uri, path)
        req = VERBS[method].new(url.request_uri)

        # Build headers and body
        options.transform_keys!(&:to_s) unless options.empty?
        headers = base_headers.merge(options.dig('headers') || options)
        headers.each{ |k,v| req[k] = v }
        req.body = (options.dig('body') || options || {}).to_json

        # Send request and process response
        resp = @connection.request(url.to_s, req)
        body = resp.body.empty? ? {} : JSON.parse(resp.body)
        Response.new(resp.code.to_i, body)

        rescue => e
          @logger.error(e.message) if @logger
          raise e
      end
  end
end