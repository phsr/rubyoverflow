module Rubyoverflow
  class Sites
    def fetch(params = {})
      hash,url = Client.stackauth_client.request 'sites', params
      
      Hashie::Mash.new hash
    end
  end

	class Client
		@sites = nil

		def sites
			@sites = Sites.new unless @sites
			@sites
		end
	end
end
