ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'

require_relative 'data_mapper_setup'

class Bookmark < Sinatra::Base
  get '/' do
    erb(:index)
  end

  enable :sessions

  post '/' do
    session[:username] = params[:username]
    session[:password] = params[:password]
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    @username = session[:username]
    erb(:links)
  end

  get '/add' do
    erb(:add)
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb(:links)
  end

  # post '/add' do
  #   link = Link.create(url: params[:url], title: params[:title])
  #   tag  = Tag.create(tags: params[:tags])
  #   link.tags << tag
  #   link.save
  #   redirect '/links'
  # end


  post '/add' do
    link = Link.create(url: params[:url], title: params[:title])
    params[:tags].split(' ').each do |tag|
      link.tags << Tag.create(name: tag)
    end
    link.save
    redirect '/links'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
