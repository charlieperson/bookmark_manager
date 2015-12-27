ENV['RACK_ENV'] ||= 'development'

require 'sinatra/flash'
require 'sinatra/base'
require_relative 'data_mapper_setup'

class Bookmark < Sinatra::Base
  use Rack::MethodOverride
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
      redirect '/links'
    else
      flash[:notice] = @user.errors.full_messages.join('. ')
      redirect '/'
    end
  end

  get '/sessions/new' do
    erb(:login)
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect '/links'
    else
      flash[:notice] = 'The email or password is incorrect'
      redirect '/sessions/new'
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

delete '/sessions' do
  session[:user_id] = nil
  flash.keep[:notice] = 'goodbye!'
  redirect '/'
end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
