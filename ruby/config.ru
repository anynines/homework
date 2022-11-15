require 'sinatra/base'
require_relative 'config/environment'
require_relative 'app/models/db_init'
require_relative 'app/routes/init'

map "/public" do
  run Rack::Directory.new("./public")
end

map '/' do
  run HomeRoutes.new
end

map '/health' do
  run HealthRoutes.new
end

map '/articles' do
  run ArticleRoutes.new
end
