ENV['RACK_ENV'] ||= 'development'

require 'sinatra/flash'
require 'sinatra/base'
require_relative 'data_mapper_setup'

class Bookmark < Sinatra::Base
  register Sinatra::Flash

  helpers do
    def current_user
     @current_user ||= User.get(session[:user_id])
    end
  end

    enable :sessions
    set :session_secret, 'super secret'

  get '/' do
    @user = User.new
    erb(:index)
  end

  post '/' do
    @user = User.create(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:notice] = "Password and confirmation password do not match"
      erb(:index)
    end
  end

  get '/links' do
    @links = Link.all
    erb(:links)
  end

  get '/add' do
    erb(:add)
  end

  post '/add' do
    link = Link.create(url: params[:url], title: params[:title])
    params[:tags].split(' ').each do |tag|
      link.tags << Tag.create(name: tag)
    end
    link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.all(name: params[:name])
    @links = tag ? tag.links : []
    erb(:links)
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
