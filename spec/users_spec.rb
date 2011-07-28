require File.dirname(__FILE__) + "/spec_helper"

describe Users do
	before(:each) do
		@client = Client.new
	end
  it "retrieves sites" do
		hash, url = @client.users.fetch
		url.should == 'http://api.stackoverflow.com/1.1/users/'
		hash['users'].should be_instance_of Array
  end

	it "retrieves phsr" do
		hash, url = @client.users.fetch(:id => 53587)
		url.should == 'http://api.stackoverflow.com/1.1/users/53587/'
		hash['users'].first['display_name'].should == 'phsr'
	end

	it "retrieves multiple users by an array of ids" do
		hash, url = @client.users.fetch(:id => [53587,22656])
		url.should == 'http://api.stackoverflow.com/1.1/users/53587;22656/'
		hash['users'].count.should == 2
	end
end
