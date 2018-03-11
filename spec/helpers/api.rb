require 'httparty'

class RubyApi

  include HTTParty

  #no_follow true

  HTTParty::Basement.default_options.update(verify: false)
    
  def initialize base_uri, prefix
    @base_uri = base_uri #You can make this an evironment variables
    @prefix = prefix #If your api has multiple versions you can change it here... e.g "/v1"
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
    $request_uri = r.request.uri #setting a global $request_uri variable so the new_html_formatter.rb inserts the URI into the report.
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
  
  #post_body converts the body to JSON which the post method does not. Some services expect this or do not so change to post if it's not needed. 
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
  
  #If your api has multiple versions you can change it here... e.g "/v1"
  def api_prefix
    @prefix
  end
end