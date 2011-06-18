require File.dirname(__FILE__) + "/spec_helper"

describe Sites do
  #context "fetch" do
  #  subject { Sites.fetch }
  #end

  it "retrieves sites" do
    hash, url = Sites.fetch
    url.should == 'http://stackauth.com/1.1/sites/'
    hash['items'].should be_instance_of Array
  end
  
  it "retrieves second page of sites" do
    hash, url = Sites.fetch :page => 2
    url.should == 'http://stackauth.com/1.1/sites/?page=2'
    hash['page'].should == 2
    hash['items'].should be_instance_of Array
  end
  
  it "retrieves a set of sites with a pagesize of 45" do
    hash, url = Sites.fetch :pagesize => 45
    url.should == 'http://stackauth.com/1.1/sites/?pagesize=45'
    hash['pagesize'].should == 45
    hash['items'].should be_instance_of Array
  end
end
