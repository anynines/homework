class ArticleController
  def create_article(article)
    article_exists = Article.exists?(title: article['title'])
  
    return { ok: false, msg: 'Article with given title already exists' } if article_exists
  
    new_article = Article.new(title: article['title'], content: article['content'], created_at: Time.now)
    
    if new_article.save
      { ok: true, obj: new_article }
    else
      { ok: false, msg: 'Failed to save the article' }
    end
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  def update_article(id, new_data)
    article = Article.find_by(id: id)
  
    return { ok: false, msg: 'Article could not be found' } unless article
  
    article.title = new_data['title']
    article.content = new_data['content']
  
    if article.save
      { ok: true, obj: article }
    else
      { ok: false, msg: 'Failed to update the article' }
    end
  rescue StandardError => e
    { ok: false, msg: e.message }
  end
  

  def get_article(id)
    res = Article.where(:id => id)

    if !res.empty?
      { ok: true, data: res[0]}
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(id)
    article = Article.find_by(id: id)
  
    if article.nil?
      { ok: false, msg: 'Article not found' }
    else
      article.destroy
      { ok: true, delete_count: 1 }
    end
  rescue StandardError => e
    { ok: false, msg: e.message }
  end
  

  def get_batch
    res = Article.all
    { ok: true, data: res}
  rescue StandardError
    { ok: false }
  end
end
