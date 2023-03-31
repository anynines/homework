class ArticleController
  def create_article(article)
    article_exists = Article.where(title: article['title']).count > 0

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    article = Article.create! title: article['title'],
        content: article['content'],
        created_at: Time.now

    { ok: true, obj: article }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, new_data)
    article = Article.where(id: id).first

    return { ok: false, msg: 'Article could not be found' } unless article

    article.update! new_data

    { ok: true, obj: article }
  rescue StandardError
    { ok: false }
  end

  def get_article(id)
    article = Article.where(id: id).first

    if article
      { ok: true, data: article }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(id)
    article = Article.where(id: id).first

    if article
      article.destroy
      { ok: true, delete_count: 1}
    else
      { ok: false }
    end
  end

  def get_batch
    {
      ok: true,
      data: Article.all
    }
  end
end
