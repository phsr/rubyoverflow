require File.dirname(__FILE__) + "/spec_helper"

describe Sites do
  before(:each) do
    @client = Client.new
  end

  it "retrieves sites" do
    result = @client.sites.fetch
    result.should respond_to(:items)
    result.page.should == 1
  end

  it "retrieves second page of sites" do
    result = @client.sites.fetch :page => 2
    result.page.should == 2
  end
end
