class ArticleController
  def create_article(article)
    article_exists = Article.where(:title => article['title']).exists?

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    new_article = Article.new(:title => article['title'], :content => article['content'], :created_at => Time.now)
    new_article.save

    { ok: true, obj: new_article }
  rescue StandardError
    { ok: false }
  end

  
def update_article(id, new_data)
    article = Article.where(id: id).first
    return { ok: false, reason: 'Article not found', msg: 'Article could not be found' } if article.nil?

    article.title = new_data['title']
    article.content = new_data['content']

    save_status = article.save
    return { ok: false, reason: 'Save failed', errors: article.errors.full_messages } unless save_status

    { ok: true, obj: article }
rescue StandardError => e
    puts "Exception raised: #{e.message}"
    { ok: false, reason: 'Exception raised', exception: e.message }
end


  def get_article(id)
    res = Article.where(:id => id)

    if res.empty?
      { ok: false, msg: 'Article not found' }
    else
      { ok: true, data: res.first }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(id)
    deleted_records = Article.where(id: id).destroy_all
    delete_count = deleted_records.size

    if delete_count > 0
      { ok: true, delete_count: delete_count }
    else
      { ok: false, msg: "Article not found or deletion failed" }
    end
  end

  def get_batch
    articles = Article.all
    { ok: true, data: articles }
  end
end
