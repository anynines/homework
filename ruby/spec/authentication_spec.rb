require 'sinatra/base'
require 'rack/test'
require 'rspec/autorun'
require 'json'
require 'base64'
require_relative '../app/middleware/auth'
require_relative '../app/routes/health'


describe HealthRoutes do
  include Rack::Test::Methods

  let(:app) { HealthRoutes.new }

  context 'testing health endpoint for authentication' do

    credentials = []
    File.foreach('config/.access') do |line|
      credentials.append(line.split('=', 2)[1].strip)
    end

    token = Base64.encode64("#{credentials[0]}:#{credentials[1]}")

    let(:response) { get '/', nil, {'HTTP_AUTHORIZATION' => "Basic #{token}" } }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      expect(response.body).to eq('App working OK')
    end
  end
end
