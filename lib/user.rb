require 'bcrypt' # make sure 'bcrypt' is in your Gemfile

class User

  include DataMapper::Resource

  property :id, Serial
  property :password_digest, Text
  property :email, String

 attr_reader :password
 attr_accessor :password_confirmation

 validates_confirmation_of :password

  validates_confirmation_of :password, message: 'Password and confirmation password do not match'

  validates_format_of :email, as: :email_address, message: 'Please enter a valid email address'
  validates_uniqueness_of :email, message: 'Email already registered'
  validates_presence_of :email, message: 'fill out the damn from mate'

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

end
