ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'
require './lib/link.rb'
require_relative 'data_mapper_setup'

class Bookmark < Sinatra::Base
  get '/' do
    erb(:index)
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
    tag  = Tag.create(tags: params[:tags])
    link.tags << tag
    link.save
    redirect '/links'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
