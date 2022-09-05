require 'sequel'

DB = Sequel.postgres ENV['DB_NAME'], user: ENV['DB_USER'], password: ENV['DB_PASS'], host: ENV['DB_HOST']

DB.drop_table?(:articles)

DB.create_table? :articles do
  primary_key :id
  String :title
  String :content
  String :created_at
end
articles = DB[:articles]

articles.insert(title: 'Title ABC', content: 'Lorem Ipsum', created_at: Time.now)
articles.insert(title: 'Title ZFX', content: 'Some Blog Post', created_at: Time.now)
articles.insert(title: 'Title YNN', content: 'O_O_O_O_O', created_at: Time.now)

puts "Article count in DB: #{articles.count}"

require_relative 'article'
