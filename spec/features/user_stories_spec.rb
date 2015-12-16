# As a User
# So that I can keep track of my bookmarks
# I want to see them displayed chronologically on a webpage

feature 'display a list of links' do
  scenario 'user is able to see list of bookmarks on homepage' do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
    visit '/links'
    expect(page.status_code).to eq 200
    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end

  scenario 'add a new link' do
    visit '/add'
    fill_in(:url, with: 'google.com')
    fill_in(:title, with: 'google')
    click_button('Submit')
    expect(page.status_code).to eq 200
    within 'ul#links' do
      expect(page).to have_content('google')
    end
  end

  scenario 'add a tag' do
    visit '/add'
    fill_in(:url, with: 'google.com')
    fill_in(:title, with: 'google')
    fill_in(:tags, with: 'search')
    click_button('Submit')
    expect(page.status_code).to eq 200
    link = Link.first
    expect(link.tags.map(&:tags)).to include('search')
  end
end
