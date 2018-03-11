require 'spec_helper'

#put the endpoint constant you're testing here to reduce duplication and insert into context for the rspec.html report...
ENDPOINT = '/posts'

describe "Example API #{ENDPOINT} Endpoint" do

  attr_accessor :api

  #Use this before block to seed test data specific to this endpoint, reduce code or speed up tests...
  before :all do
    self.api = @api
    #you can seed your test data here or in each test for specific reasons...    
  end

  #Use available rspec matchers or create custom ones.
  #https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
  context "GET #{ENDPOINT}" do
    #This is the before block of this set of tests/it's
    before(:all) do
      @get = api.get(ENDPOINT)
      #Use pry in before block to debug the response. e.g. @get.code, @get.body, @get.response, list available methods -> @get.methods etc...
      #binding.pry
    end
    #using it{...} is good here because if one assertion fails it continues to the next...
    it { expect(@get.code).to eq 200 }
    it { expect(json_parse(@get.body)).not_to be_empty }
  end

  context "GET Specific ID: #{ENDPOINT}/1" do
    #you can also write your blocks like this to save space using curly braces...
    before(:all) { @get = api.get("#{ENDPOINT}/1") } #;binding.pry }
    it { expect(@get.code).to eq 200 }
    it { expect(@get.body.is_a? String).to eq true }
    #or explicitly check that the field equals the value you expect. You can also seed this by doing a POST in the before :all block.
    it { expect(json_parse(@get.body)).not_to be_empty }
    it { expect(@get["userId"].is_a? Integer).to eq true }
    it { expect(@get["userId"]).to be > 0 }
    it { expect(@get["userId"]).to eq 1 }
    it { expect(@get["id"].is_a? Integer).to eq true }
    it { expect(@get["id"]).to eq 1 }
    it { expect(@get["title"].is_a? String).to eq true }
    it { expect(@get["title"]).to eq "sunt aut facere repellat provident occaecati excepturi optio reprehenderit" }
  end

  context "GET Posts Comments: #{ENDPOINT}/1/comments" do
    before(:all) { @get = api.get("#{ENDPOINT}/1/comments") }
    it { expect(@get.code).to eq 200 }
    it { expect(@get.body.is_a? Integer).to be_truthy, "Expected validation to be true, but got false. This should be a String!" } #Example of a custom matcher. Fail on purpose.
    it { expect(json_parse(@get.body)).not_to be_empty }
  end

  context "POST Posts: #{ENDPOINT}" do
    before(:all) do
      @title = random_word
      @body = random_sentence
      @userId = rand(1..5)
      @post = api.post_body(ENDPOINT, { title: @title, body: @body, userId: @userId })
      #Get the POST'ed record
      #Note: the resource id "@post["id"]" will not be really created on the server but it will be faked as if.
      #https://github.com/typicode/jsonplaceholder#how-to
      #You can now assert the POST data is correct by doing a GET.
      @get = api.get("#{ENDPOINT}/#{@post["id"]}")
    end
    it { expect(@post.code).to eq 201 }
    it { expect(@post.body.is_a? String).to eq true }
    it { expect(json_parse(@post.body)).not_to be_empty }
    it { expect(@get.code).to eq 200 }
    it { expect(@get["userId"]).to eq  @userId }
    #Commented out these so the report doesn't show so many errors...
    # it { expect(@get["id"].is_a? Integer).to eq true }
    # it { expect(@get["id"]).to eq @post["id"] }
    # it { expect(@get["title"].is_a? String).to eq true }
    # it { expect(@get["title"]).to eq @title }
    # it { expect(@get["body"].is_a? String).to eq true }
    # it { expect(@get["body"]).to eq @body }
  end

  context "PUT Posts: #{ENDPOINT}" do
    before(:all) do
      @id = rand(1..5)
      @title = random_word
      @body = random_sentence
      @userId = 1
      @put = api.put("#{ENDPOINT}/1", { id: @id, title: @title, body: @body, userId: @userId })
      #binding.pry
      #Get the PUT'ed record
      #Note: the resource id "@put["id"]" will not be really created on the server but it will be faked as if.
      #https://github.com/typicode/jsonplaceholder#how-to
      #You can now assert the PUT data is correct by doing a GET.
      @get = api.get("#{ENDPOINT}/#{@id}")
    end
    it { expect(@put.code).to eq 200 }
    it { expect(@put.body.is_a? String).to eq true }
    it { expect(json_parse(@put.body)).not_to be_empty }
    it { expect(@get.code).to eq 200 }
    it { expect(@get["userId"]).to eq  @userId }
    it { expect(@get["id"].is_a? Integer).to eq true }
    it { expect(@get["id"]).to eq @id }
    it { expect(@get["title"].is_a? String).to eq true }
    it { expect(@get["title"]).to eq @title }
    it { expect(@get["body"].is_a? String).to eq true }
    it { expect(@get["body"]).to eq @body }
  end
  
  context "DELETE Posts: #{ENDPOINT}/1" do
    before(:all) do
      #You could seed this data by doing a POST first, then DELETE, then do a GET to make sure it's deleted.
      @delete = api.delete("#{ENDPOINT}/1")
      #The delete doesn't actually delete so the assertions for this GET will fail. 
      #You'd want to check that the GET gets a 404 if it really did delete the record.
      @get = api.get("#{ENDPOINT}/1")
    end
    it { expect(@delete.code).to eq 200 }
    it { expect(@get.code).to eq 404 }
  end
end