module Rubyoverflow
	class Users
		class << self
			def fetch(params = {})
				Client.request 'users', params
			end
		end
	end
end
