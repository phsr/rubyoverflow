path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'httparty'
require 'zlib'
require 'ostruct'
require 'hashie'

require 'rubyoverflow/sites'
require 'rubyoverflow/users'

module Rubyoverflow
  class Client
    include HTTParty
    format :json
    #Most of this class is borrowed from the Pilha (http://github.com/dlt/pilha) project because a) it works, b) a lot of this code would be the same regardless of implementation
    # (especially the open => gzip code, query string, and normalize), and c) I'm new to ruby, so I'm going to skip pass some of the more 'boring' stuff and get to the 
    # interesting parts.  I plan to re-examine this at a later point
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
      parameters['key'] = @api_key unless @api_key.empty?
      url = host_path + normalize(path) + query_string(parameters)
      response = self.class.get url
      return response.parsed_response, url
    end
    
    def host_path
      normalize(@host) +  normalize(@version)
    end
    
    class << self
      # this specifically works well, and I don't fully understand it, so I borrowed this from Pilha more than anything else
      # If you want to explain why I only have to configure this once than forget about it, please do, because this stuff is currently over my head
      def config &block
        options = OpenStruct.new
        yield options if block_given?
        init_client! Client.new(options)
      end
      
      def change_end_point(val = nil)
        options = OpenStruct.new
        if val.kind_of? ApiSite
          options.host = val.api_endpoint
        end

        if val.kind_of? String
          options.host = val
        end
        options.api_key = Base.client.api_key
        
        init_client! Client.new(options)
      end
      
      def init_client!(client)
        base_eigenclass = class << Base; self; end
        base_eigenclass.send :define_method, :client do
          @client = client
        end
        client
      end
      
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
