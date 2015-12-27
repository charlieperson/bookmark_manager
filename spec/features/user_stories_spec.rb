require './spec/helpers/web_helper.rb'

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
    expect(link.tags.map(&:name)).to include('search')
  end


  # As a time-pressed user
  # So that I can quickly find links on a particular topic
  # I would like to filter links by tag
  scenario 'I can filter links by tag' do
      Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy', tags: [Tag.first_or_create(name: 'education')])
      Link.create(url: 'http://www.google.com', title: 'Google', tags: [Tag.first_or_create(name: 'search')])
      Link.create(url: 'http://www.zombo.com', title: 'This is Zombocom', tags: [Tag.first_or_create(name: 'bubbles')])
      Link.create(url: 'http://www.bubble-bobble.com', title: 'Bubble Bobble', tags: [Tag.first_or_create(name: 'bubbles')])

    visit '/tags/bubbles'
    expect(page.status_code).to eq(200)
    within 'ul#links' do
      expect(page).not_to have_content('Makers Academy')
      expect(page).not_to have_content('Code.org')
      expect(page).to have_content('This is Zombocom')
      expect(page).to have_content('Bubble Bobble')
    end
  end


  # As a time-pressed user
  # So that I can organise my links into different categories for ease of search
  # I would like to add tags to the links in my bookmark manager
  scenario 'add multiple tags to the one link' do
    visit '/add'
    fill_in(:url, with: 'charlielearnscode.com')
    fill_in(:title, with: 'Chucks blog')
    fill_in(:tags, with: 'blog social')
    click_button('Submit')
    expect(page.status_code).to eq 200
    link = Link.first
    expect(link.tags.map(&:name)).to include('blog')
    expect(link.tags.map(&:name)).to include('social')
  end


  # when a user signs up, the User count increases by 1
  feature 'User sign up' do
    scenario 'I can sign up as a new user' do
      expect { sign_up }.to change(User, :count).by(1)
      expect(page).to have_content('Welcome, alice@example.com')
      expect(User.first.email).to eq('alice@example.com')
    end

    scenario 'requires a matching confirmation password' do
      expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    end

    scenario 'with a password that does not match' do
      expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
      expect(current_path).to eq('/') # current_path is a helper provided by Capybara
      expect(page).to have_content 'Password does not match the confirmation'
    end

    scenario 'require email field in order to sign up' do
      visit '/'
      expect{ sign_up(email: nil) }.to change(User, :count).by(0)
    end

    scenario 'require correctly formatted email' do
      sign_up
      sign_up
      expect(page).to have_content "Email already registered"
    end
  end

  scenario 'allows users to sign in' do
    sign_up
    visit '/'
    click_button('Already have an account?')
    fill_in(:email, with: 'alice@example.com')
    fill_in(:password, with: '12345678')
    click_button('Log in')
    expect(page).to have_content "Welcome, alice@example.com"
  end

  scenario 'allows users to sign out' do
    sign_up
    click_button('log out')
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content('Welcome, alice@example.com')
  end
end
