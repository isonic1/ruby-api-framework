require 'httparty'

class RubyApi

  include HTTParty

  #debugging for HTTParty
  #debug_output $stdout
  #no_follow true

  HTTParty::Basement.default_options.update(verify: false)

  BOUNDARY = "AaB03x"
    
  def initialize base_uri
    @base_uri = base_uri #You can make this an evironment variables
    initialize_httparty
  end

  def initialize_httparty
    self.class.base_uri @base_uri
    self.class.format :json
    self.class.default_options.update(verify: false)
    self.class.headers({"Content-Type"=> "application/json"})
  end
  
  RequestFailed = Class.new(StandardError)

  def get(path, params = {})        
    r = self.class.get(api_prefix + path, query: params)
    begin
      unless [200, 204, 302].include? r.code
        raise RequestFailed, "GET #{path} & #{params.inspect} with status #{r.code}"
      end
    rescue StandardError => e
      puts "There was an exception (#{e.class}: #{e.message})"
    end
    $request_uri = r.request.uri
    r
  end

  def post(path, params = {})
    r = self.class.post(api_prefix + path, body: params)
    begin
      unless [200, 201].include? r.code
        raise RequestFailed, "POST #{path} & #{params.inspect} with status #{r.code}"
      end
    rescue StandardError => e
      puts "There was an exception (#{e.class}: #{e.message})"
    end
    $request_uri = "#{r.request.uri} body: #{r.request.options[:body]}"
    r
  end
  
  def post_body(path, body = {})
    r = self.class.post(api_prefix + path, body: JSON.generate(body))
    begin
      unless [200, 201].include? r.code
        raise RequestFailed, "POST #{path} & #{body.inspect} with status #{r.code}"
      end
    rescue StandardError => e
      puts "There was an exception (#{e.class}: #{e.message})"
    end
    $request_uri = "#{r.request.uri} body: #{r.request.options[:body]}"
    r
  end
  
  def post_form(path, body = {})
    r = self.class.post(api_prefix + path, body)
    begin
      unless [200, 201].include? r.code
        raise RequestFailed, "POST #{path} & #{body.inspect} with status #{r.code}"
      end
    rescue StandardError => e
      puts "There was an exception (#{e.class}: #{e.message})"
    end
    $request_uri = "#{r.request.uri} body: #{r.request.options[:body]}"
    r
  end

  def patch(path, body = {})
    r = self.class.patch(api_prefix + path, body: JSON.generate(body))
    begin
      unless r.code == 200
        raise RequestFailed, "PATCH #{path} & #{body.inspect} with status #{r.code}"
      end
    rescue StandardError => e
      puts "There was an exception (#{e.class}: #{e.message})"
    end
    $request_uri = "#{r.request.uri} body: #{r.request.options[:body]}"
    r
  end

  def put(path, body = {})
    r = self.class.put(api_prefix + path, body: JSON.generate(body))
    begin
      unless r.code == 200
        raise RequestFailed, "PUT #{path} & #{body.inspect} with status #{r.code}"
      end
    rescue StandardError => e
      puts "There was an exception (#{e.class}: #{e.message})"
    end
    $request_uri = "#{r.request.uri} body: #{r.request.options[:body]}"
    r
  end

  def delete(path, params = {})
    r = self.class.delete(api_prefix + path, query: params, body: nil)
    begin
      unless [204, 200].include? r.code
        raise RequestFailed, "DELETE #{path} & #{params.inspect} with status #{r.code}"
      end
    rescue StandardError => e
      puts "There was an exception (#{e.class}: #{e.message})"
    end
    $request_uri = r.request.uri
    r
  end

  private
  
  #If your api has multiple versions you can change it here...
  def api_prefix
    #"/v1"
    "" #setting to empty string for this test API
  end
end