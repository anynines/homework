class ArticleController
  def create_article(article)
    article_not_exists = ! (Article.where(:title => article['title']).empty?)

    return { ok: false, msg: 'Article with given title already exists' } unless article_not_exists

    new_article = Article.new(:title => article['title'], :content => article['content'], :created_at => Time.now)
    new_article.save

    { ok: false, obj: article }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, new_data)

    article = Article.where(id: id).first

    return { ok: false, msg: 'Article could not be found' } unless article.nil?

    article.title = new_data['title']
    article.content = new_data['content']
    article.save_changes

    { ok: true }
  rescue StandardError
    { ok: false }
  end

  def get_article(id)
    res = Article.where(:id => id)

    if res.empty?
      { ok: true, data: res }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(_id)
    delete_count = Article.delete(:id => id)

    if delete_count == 0
      { ok: true }
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def get_batch
    
  end
end
