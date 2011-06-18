module Rubyoverflow
  class Sites
    class << self
      def fetch(params = {})
        Client.stackauth_client.request 'sites', params
      end
    end
  end
end
