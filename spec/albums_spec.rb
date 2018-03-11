require 'spec_helper'

#put the endpoint constant you're testing here to reduce duplication and insert into context for the rspec.html report...
ALBUMS = '/albums'

describe "Example API #{ALBUMS} Endpoint" do

  attr_accessor :api

  #Use this before block to seed test data specific to this endpoint, reduce code or speed up tests...
  before :all do
    self.api = @api
    #you can seed your test data here or in each test for specific reasons... 
    #seed example
    @get_all = api.get ALBUMS   
  end
  
  #Use "xit" to set pending tests. You would use this if the endpoint wasn't ready or keeps failing...
  context "GET #{ALBUMS}" do
    it { expect(@get_all.code).to eq 200 }
    xit { expect(json_parse(@get_all.body)).not_to be_empty }
  end

  context "GET Specific Album: #{ALBUMS}/1" do
    #This example shows you how to pass in query parameters
    before(:all) { @get = api.get("#{ALBUMS}/1") }
    it { expect(@get.code).to eq 200 }
    it { expect(@get.body.is_a? String).to eq true }
    it { expect(json_parse(@get.body)).not_to be_empty }
    it { expect(@get.count).to eq 3 }
    it { expect(@get["userId"].is_a? Integer).to eq true }
    it { expect(@get["userId"]).to be > 0 }
    it { expect(@get["userId"]).to eq 1 }
    it { expect(@get["id"].is_a? Integer).to eq true }
    it { expect(@get["id"]).to be > 0 }
    it { expect(@get["id"]).to eq 1 }
    it { expect(@get["title"].is_a? String).to eq true }
    it { expect(@get["title"]).to eq "quidem molestiae enim" }
  end
end