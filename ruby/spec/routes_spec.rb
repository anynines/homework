require 'sinatra/base'
require 'rack/test'
require 'rspec/autorun'
require 'json'
require_relative '../app/routes/health'
require_relative '../app/routes/home'
require_relative './stubs/stub_middleware'
require_relative '../app/routes/articles'


describe HomeRoutes do
  include Rack::Test::Methods

  let(:app) { HomeRoutes.new }

  context 'testing the homepage endpoint GET /' do
    let(:response) { get '/' }

    it 'checks response status' do
      expect(response.status).to eq 200
    end
  end
end


describe ArticleRoutes do
  include Rack::Test::Methods

  let(:app) { ArticleRoutes.new }

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init' # initializes the database schema; uses ENV credentials
  end

  context 'testing the get articles endpoint GET /' do
    let(:response) { get '/' }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('articles')
      expect(hashed_response['articles'].length).to eq(3)
    end
  end

  context 'testing the get single article endpoint GET /2' do
    let(:response) { get '/2' }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('article')
      expect(hashed_response['article']).to be_truthy
    end
  end

  context 'testing the get single article endpoint GET /99' do
    let(:response) { get '/99' }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to be_truthy
    end
  end

  context 'testing the create article endpoint ' do
    let(:response) do
      post '/', JSON.generate('title' => 'Route Test Article', 'content' => 'test content'),
           'CONTENT_TYPE' => 'application/json'
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article created')
    end
  end

  context 'testing the update article endpoint ' do
    let(:response) do
      put '/2', JSON.generate('title' => 'Updated Test Article', 'content' => 'update'),
          'CONTENT_TYPE' => 'application/json'
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article updated')
    end
  end

  context 'testing the delete article endpoint ' do
    let(:response) { delete '/2' }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article deleted')
    end
  end

  context 'testing the delete article endpoint; wrong id' do
    let(:response) { delete '/99' }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article does not exist')
    end
  end
end
