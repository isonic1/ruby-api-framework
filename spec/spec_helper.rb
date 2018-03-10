require_relative '../spec/helpers/helpers'
require 'rspec'
require 'faker'
require 'awesome_print'
require 'colorize'
require 'pry'

include Faker

RSpec.configure do |config|
  config.formatter = :documentation
  config.example_status_persistence_file_path = "failures.txt"
  config.run_all_when_everything_filtered = true
  config.fail_fast = false
  
  #This is a good practice to build robust tests and expecting that everything runs in order. Especially when you run in parallel.
  config.order = :random 
  
  #Before Suite hook
  config.before :all do
    #initialize the API Class
    @api = RubyApi.new("https://jsonplaceholder.typicode.com") #You can make this URI an environment variable if you want...
  end
  
  #After Suite hook
  config.after :each do
   
  end
  
  #Before each Spec hook
  config.before :each do
  
  end
  
  #After each Spec hook
  config.after :each do
  
  end
end