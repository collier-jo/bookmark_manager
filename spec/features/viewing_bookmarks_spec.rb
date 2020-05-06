feature 'Viewing bookmarks' do
  scenario 'visits index page' do
    visit('/')
    expect(page).to have_content 'Bookmark Manager'
  end

  scenario "Directs to /bookmarks" do
    visit ('/bookmarks')
    expect(page).to have_content 'All Bookmarks:'
  end

  scenario "Shows array of bookmarks" do
    connection = PG.connect(dbname: 'bookmark_manager_test')

    Bookmark.create(url: "http://www.makersacademy.com")
    Bookmark.create(url: "http://www.destroyallsoftware.com")
    Bookmark.create(url: "http://www.google.com")

    visit('/bookmarks')
    expect(page).to have_content 'http://www.makersacademy.com'
    expect(page).to have_content 'http://www.google.com'
    expect(page).to have_content 'http://www.destroyallsoftware.com'
  end
end 

