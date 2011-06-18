require File.dirname(__FILE__) + "/spec_helper"

describe Users do
  it "retrieves sites" do
		hash, url = Users.fetch
		url.should == 'http://api.stackoverflow.com/1.1/users/'
		hash['users'].should be_instance_of Array
  end
end
