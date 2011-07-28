module Rubyoverflow
  class Sites
    def fetch(params = {})
      Client.stackauth_client.request 'sites', params
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
