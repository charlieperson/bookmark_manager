require 'bcrypt' # make sure 'bcrypt' is in your Gemfile

class User

  include DataMapper::Resource

  property :id, Serial
  property :password_digest, Text
  property :email, String

 attr_reader :password
 attr_accessor :password_confirmation

 validates_confirmation_of :password


  validates_format_of :email, as: :email_address, message: 'Please enter a valid email address'
  validates_uniqueness_of :email, message: 'Email already registered'
  validates_presence_of :email, message: 'fill out the damn from mate'

  def self.authenticate(email, password)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      # return this user
      user
    else
      nil
    end
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

end
