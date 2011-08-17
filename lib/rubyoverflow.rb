path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'httparty'
require 'ostruct'

require 'hashie'
require 'json'
require 'rubyoverflow/sites'
require 'rubyoverflow/users'
require "rubyoverflow/version"

module Rubyoverflow
  class Client
    include HTTParty
    format :plain
    HOST = 'http://api.stackoverflow.com'
    VERSION = '1.1'

    attr_reader :host
    attr_reader :api_key
    
    def initialize(options = OpenStruct.new)
      if options.kind_of? OpenStruct
        @host = options.host || HOST
        @version = options.version || VERSION
        @api_key = options.api_key if options.api_key
      end
    end

    def request(path, parameters = {})
      parameters['key'] = @api_key unless @api_key.nil? || @api_key.empty?
      url = host_path + normalize(path) + query_string(parameters)
      response = self.class.get url
      return JSON.parse(response.body), url
    end
    
    def host_path
      normalize(@host) +  normalize(@version)
    end
    
    class << self
            
      def stackauth_client(api_key = '')
        options = OpenStruct.new
        options.host = 'http://stackauth.com/'
        options.api_key = api_key if api_key
        Client.new options
      end
    end

    private
    def normalize(path)
      path.end_with?('/') ? path : path+ '/'
    end
    
    def query_string(parameters)
      if !parameters.empty?
        params = parameters.sort_by { |k, v| k.to_s }
        pairs  = params.map { |key, value| "#{key}=#{value}" }
        
        '?' + pairs.join('&')
      else
        ''
      end
   end
  end
end
