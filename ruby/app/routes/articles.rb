require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

 get('/') do
  summary = @articleCtrl.get_batch

  if summary[:ok]
    { articles: summary[:data] }.to_json
  else
    status 500
    { msg: 'Could not get articles.' }.to_json
  end
  end

  get('/:id') do
    article_id = params["id"]
    summary = @articleCtrl.get_article(article_id)
    
    if summary[:ok]
      {article: summary[:data]}.to_json
    else
      status 404
      { msg: 'Could not get article with id ' + article_id }.to_json
    end
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.create_article(payload)

    if summary[:ok]
      { msg: 'Article created' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  put('/:id') do
    article_id = params["id"]
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.update_article(article_id, payload)

    if summary[:ok]
      { msg: 'Article updated' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  delete('/:id') do
    article_id = params["id"]
    summary = @articleCtrl.delete_article(article_id)

    if summary[:ok]
      { msg: 'Article deleted' }.to_json
    else
      { msg: 'Article does not exist' }.to_json
    end
  end
end
