module Rubyoverflow
  class Users

    def initialize(client)
      @client = client
    end

    def fetch(params = {})
      ids = params.delete(:id) if params[:id]
      ids = ids.join(';') if ids and ids.kind_of? Array
      hash,url = @client.request "users#{"/#{ids}" if ids}", params

      Hashie::Mash.new hash
    end
  end

  class Client
    @users = nil

    def users
      @users ||= Users.new(self)
    end
  end
end
