module Rubyoverflow
	class Users

		def initialize(client)
			@client = client

		end
		
		def fetch(params = {})
			ids = params.delete(:id) if params[:id]
			ids = ids.join(';') if ids and ids.kind_of? Array
			@client.request "users#{"/#{ids}" if ids}", params
		end
	end
	

end
