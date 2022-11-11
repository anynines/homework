class ArticleController
  def create_article(article)
    article_exists = Article.where(tilte: 'title')

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    new_article = Article.new
    new_article.set_fields({ title: article['title'], content: article['content'], created_at: Time.now },
                           %i[title content created_at])
    new_article.save_changes

    { ok: false, obj: article }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, new_data)
    article = Article.where(id: id).first

    return { ok: false, msg: 'Article could not be found' } unless article.nil?

    article.set_fields({ title: new_data['title'], content: new_data['content'] }, %i[title content])
    article.save_changes

    { ok: true }
  rescue StandardError
    { ok: false }
  end

  def get_article(id)
    res = Article.where(id: id)

    if res.empty?
      data = []

      res.each do |r|
        data.append(r.to_hash)
      end

      { ok: true, data: data.first }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(_id)
    delete_count = Article.where(id: 9).delete

    if delete_count == 0
      { ok: true }
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def get_batch
    
  end
end
