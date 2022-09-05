require 'rspec/autorun'
require 'dotenv'
require_relative '../app/controllers/articles'

describe ArticleController do
  let(:controller) { ArticleController.new }

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init' # initializes the database schema; uses ENV credentials
  end

  it 'gets an article from db' do
    result = controller.get_article(1)
    expect(result).to have_key(:ok)
    expect(result).to have_key(:data)
    expect(result[:ok]).to be true
    expect(result[:data]).to be_truthy
    expect(result[:data][:title]).to eq('Title ABC')
  end

  it 'gets all articles from db' do
    result = controller.get_batch
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:data)
    expect(result[:data]).to be_truthy
    expect(result[:data].length).to eq(3)
  end

  it 'adds a test article to db' do
    article = { 'title' => 'Test Article', 'content' => 'This article was created in a unit test' }
    result = controller.create_article(article)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
  end

  it 'attempts to create the test article again' do
    article = { 'title' => 'Test Article', 'content' => 'This article was created in a unit test' }
    result = controller.create_article(article)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
    expect(result).to have_key(:msg)
  end

  it 'updates the test article in db' do
    article = { 'title' => 'Test Article', 'content' => 'The article was updated using Rspec' }
    result = controller.update_article(4, article)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
  end

  it 'tries to update a non-existent article in db' do
    article = { 'title' => 'Non Existent Article', 'content' => 'The article was updated using Rspec' }
    result = controller.update_article(99, article)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
  end

  it 'deletes the test article from db' do
    result = controller.delete_article(4)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:delete_count)
    expect(result[:delete_count]).to eq(1)
  end

  it 'tries to delete a non-existent article' do
    result = controller.delete_article(99)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
  end
end
