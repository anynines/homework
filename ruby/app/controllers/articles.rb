class ArticleController
  def create_article(article)
    article_exists = ! (Article.where(:title => article['title']).empty?)

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    new_article = Article.new(:title => article['title'], :content => article['content'], :created_at => Time.now)
    new_article.save

    { ok: true, obj: article }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, new_data)

    article = Article.where(id: id).first

    return { ok: false, msg: 'Article could not be found' } unless article

    article.update(new_data)

    { ok: true, obj: article }
  rescue StandardError
    { ok: false }
  end

  def get_article(id)
    article = Article.find(id)

    if article
      { ok: true, data: article }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(_id)
    delete_count = Article.delete(_id)

    if delete_count == 0
      { ok: false }
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def get_batch
    articles = Article.all

    if articles.empty?
      { ok: false, msg: 'No articles found' }
    else
      { ok: true, data: articles.to_a }
    end
  end
end
