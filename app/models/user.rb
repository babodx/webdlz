class User < ActiveRecord::Base
  has_and_belongs_to_many :zonenames
  has_many :users_roles
  has_many :roles, :through => :users_roles

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :omniauthable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :wmid
  # attr_accessible :title, :body

  def self.find_for_webmoney_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']
    if user = User.find_by_wmid(data['WmLogin_WMID'])
      user
    else # Create an user with a stub password.
      User.create!(:email => "#{data['WmLogin_WMID']}@wmkeeper.com", :wmid => "#{data['WmLogin_WMID']}")#, :password => Devise.friendly_token[0,20])
    end
  end
end
