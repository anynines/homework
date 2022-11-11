require 'sinatra/base'
require 'rack/test'
require 'rspec/autorun'
require 'json'
require 'base64'
require_relative '../app/middleware/auth'
require_relative '../app/routes/health'
require_relative './helpers/headers'

describe HealthRoutes do
  include Rack::Test::Methods

  let(:app) { HealthRoutes.new }

  context 'testing health endpoint for authentication' do

    let(:response) { get '/', nil, prepare_headers(HeaderType::HTTP_AUTH) }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      expect(response.body).to eq('App working OK')
    end
  end
end
