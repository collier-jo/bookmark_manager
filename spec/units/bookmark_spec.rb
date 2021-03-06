require 'bookmark'
require 'database_helpers'

describe Bookmark do
  describe '.all' do
    it 'returns all bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

      # Add the test data
      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      Bookmark.create(url: "http://www.destroyallsoftware.com", title: "Destroy all Software")
      Bookmark.create(url: "http://www.google.com", title: "Google")

      bookmarks = Bookmark.all

      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'Makers Academy'
      expect(bookmarks.first.url).to eq 'http://www.makersacademy.com'
    end
  end

  describe '.create' do
    it 'creates a new bookmark' do
      bookmark = Bookmark.create(url: 'https://www.reddit.com/r/birdswitharms/', title: 'Birds With Arms')
      persisted_data = persisted_data(id: bookmark.id)

      p "VVVV persisted_data VVVV"
      p persisted_data
      p "^^^^^ persisted_data ^^^^^^"

      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data['id']
      expect(bookmark.title).to eq 'Birds With Arms'
      expect(bookmark.url).to eq 'https://www.reddit.com/r/birdswitharms/'
    end
  end

  describe '.delete' do 
    it 'deletes the given bookmark' do 
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')

      Bookmark.delete(id: bookmark.id)

      expect(Bookmark.all.length).to eq 0
    end
  end

  describe '.update' do 
    it 'updates the bookmark with given data' do 
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      updated_bookmark = Bookmark.update(id: bookmark.id, url: 'http://www.snakersacademy.com', title: 'Snakers Academy')
      
      expect(updated_bookmark).to be_a Bookmark
      expect(updated_bookmark.id).to eq bookmark.id
      expect(updated_bookmark.title).to eq 'Snakers Academy'
      expect(updated_bookmark.url).to eq 'http://www.snakersacademy.com'
    end 
  end

  describe '.create' do 
    it 'does not create an invalid URL' do 
      Bookmark.create(url: 'not a real bookmark', title: 'not a real bookmark')
      expect(Bookmark.all).to be_empty
    end 
  end 

  describe '.comments' do 
    it "returns a list of comments" do 
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      DatabaseConnection.query ("INSERT INTO comments(id, text, bookmark_id) VALUES(1, 'Test comment', #{bookmark.id})")

      comment = bookmark.comments.first

      expect(comment['text']).to eq('Test comment')
    end 
  end 
end  
