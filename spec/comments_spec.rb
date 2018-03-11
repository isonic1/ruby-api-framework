require 'spec_helper'

#put the endpoint constant you're testing here to reduce duplication and insert into context for the rspec.html report...
ENDPOINT = '/comments'

describe "Example API #{ENDPOINT} Endpoint" do

  attr_accessor :api

  #Use this before block to seed test data specific to this endpoint, reduce code or speed up tests...
  before :all do
    self.api = @api
    #you can seed your test data here or in each test for specific reasons...    
  end

  context "GET Comment: #{ENDPOINT}" do
    #This example shows you how to pass in query parameters
    #get[0] gets the first index of the results output
    before(:all) { @get = api.get(ENDPOINT, { postId: 5 }) }
    it { expect(@get.code).to eq 200 }
    it { expect(@get.body.is_a? String).to eq true }
    it { expect(json_parse(@get.body)).not_to be_empty }
    it { expect(@get.count).to eq 5 }
    it { expect(@get[0]["postId"].is_a? Integer).to eq true }
    it { expect(@get[0]["postId"]).to be > 0 }
    it { expect(@get[0]["postId"]).to eq 5 }
    it { expect(@get[0]["name"].is_a? String).to eq true }
    it { expect(@get[0]["name"]).to eq "aliquid rerum mollitia qui a consectetur eum sed" }
    it { expect(@get[0]["email"].is_a? String).to eq true }
    it { expect(@get[0]["email"]).to eq "Noemie@marques.me" }
  end
end