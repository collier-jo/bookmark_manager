feature "add bookmarks" do
  feature 'Adding a new bookmark' do
    scenario 'A user can add a bookmark to Bookmark Manager' do
      visit('/bookmarks/new')
      fill_in('url', with: 'https://www.reddit.com/r/birdswitharms/')
      fill_in('title', with: 'Birds With Arms')
      click_button('submit')

      expect(page).to have_link('Birds With Arms', href: 'https://www.reddit.com/r/birdswitharms/')
    end

    scenario 'The bookmark must be a valid URL' do
      visit('/bookmarks/new')
      fill_in('url', with: 'not a real bookmark')
      click_button('submit')
    
      expect(page).not_to have_content "not a real bookmark"
      expect(page).to have_content "You must submit a valid URL."
    end
  end
end 
