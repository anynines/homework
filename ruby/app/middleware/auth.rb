require 'json'
require 'base64'

class AuthMiddleware
  def initialize(app)
    @app = app
    @stored_creds = []

    File.foreach('config/.access') do |line|
      @stored_creds.append(line.split('=', 2)[1].strip)
    end
  end

  def call(env)
    auth_token = env.fetch('HTTP_AUTHORIZATION')[6..]
    creds = Base64.decode64(auth_token).force_encoding('UTF-8').split(':', 2)

    if creds[0].eql?(@stored_creds[0]) && creds[1].eql?(@stored_creds[1])
      @req = Rack::Request.new(env)
      @req.set_header('AUTHED', true)

      status, headers, response = @app.call(env)
      [status, headers, response]
    else
      Rack::Response.new('UNAUTHORIZED', 401, {}).finish
    end
  rescue StandardError => e
    Rack::Response.new('SOMETHING WENT WRONG!', 501, {}).finish
  end
end