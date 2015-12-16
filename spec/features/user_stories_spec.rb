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


  # As a time-pressed user
  # So that I can quickly find links on a particular topic
  # I would like to filter links by tag
  scenario 'I can filter links by tag' do
      Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy', tags: [Tag.first_or_create(tags: 'education')])
      Link.create(url: 'http://www.google.com', title: 'Google', tags: [Tag.first_or_create(tags: 'search')])
      Link.create(url: 'http://www.zombo.com', title: 'This is Zombocom', tags: [Tag.first_or_create(tags: 'bubbles')])
      Link.create(url: 'http://www.bubble-bobble.com', title: 'Bubble Bobble', tags: [Tag.first_or_create(tags: 'bubbles')])



    visit '/tags/bubbles'
    expect(page.status_code).to eq(200)
    within 'ul#links' do
      expect(page).not_to have_content('Makers Academy')
      expect(page).not_to have_content('Code.org')
      expect(page).to have_content('This is Zombocom')
      expect(page).to have_content('Bubble Bobble')
    end
  end
end
