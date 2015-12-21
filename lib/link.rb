class Link
  include DataMapper::Resource
  property :id,    Serial
  property :title, String
  property :url,   String
  property :user,  String

  has n, :tags, :through => Resource
  # has n, :users, :through => Resource
end
