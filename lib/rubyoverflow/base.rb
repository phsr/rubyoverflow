module Rubyoverflow
  class Base

    def request(path, parameters = {})
      Base.request(path, parameters)
    end
  
    def find_parse_querystring(rawurl)
      queryHash = {}
      if rawurl.include? '?'
      url, querystring = rawurl.split('?')
      
      if querystring
        querystring.split('&').each {|pair|
          key,value=pair.split('=')
          queryHash[key]=value 
        }
        queryHash
      end
      url.sub!(Base.client.host_path,'')
      return url,queryHash
      
      else
      url = rawurl
      end
      url.sub!(Base.client.host_path,'')
      return url,queryHash
    end
    
    class << self
      def client 
        @client ||= Rubyoverflow::Client.config
      end
    
      def request(path, parameters = {})
        client.request(path, parameters)
      end
      
      def convert_to_id_list(id)
        id = convert_if_array(id)
        id = id.item_id if id.respond_to?(:item_id)
        id.to_s
      end
      
      def convert_if_array(id)
        new_id_list = Array.new
        if id.kind_of?(Array)
          id.each do |item|
            if item.respond_to? :item_id
              new_id_list.push item.item_id
            elsif item.kind_of?(String) || item.kind_of?(Integer)
              new_id_list.push item
            end
          end
          return new_id_list.join(';')
        else
          return id
        end
      end
      
      def change_end_point(endpoint)
        Client.change_end_point endpoint
      end
    end
    
  end

  class BaseDash < Hashie::Dash
    def initialize(hash={})
      hash2 = Hash.new
      hash.each { |key, value| hash2[key.strip] = value  }
      hash = hash2
      super(hash)
    end
  end
end