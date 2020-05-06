require 'pg'

class Bookmark
  def self.all
    bookmarks = []

    if ENV['ENVIRONMENT'] == 'test'
      con = PG.connect :dbname => 'bookmark_manager_test'
    else
      con = PG.connect :dbname => 'bookmark_manager'
    end

    result = con.exec('SELECT * FROM bookmarks;')
    result.each do |x|
      bookmarks << x['url']
    end

    bookmarks
  end

  def self.create(url:) 

    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect :dbname => 'bookmark_manager_test'
    else 
      connection = PG.connect :dbname => 'bookmark_manager'
    end 

    connection.exec("INSERT INTO bookmarks (url) VALUES('#{url}')")
  end 
end
