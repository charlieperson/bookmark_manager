require 'data_mapper'
require 'dm-postgres-adapter'
require './lib/tag.rb'
require './lib/link.rb'
require './lib/user.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{ENV['RACK_ENV']}")
DataMapper.finalize
