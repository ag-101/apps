class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login
  # attr_accessible :title, :body

#  after_save :get_ldap_info
  has_and_belongs_to_many :roles
  has_many :apps
  
  def role?(role)
      return !!self.roles.find_by_name(role.to_s.camelize)
  end  
end


