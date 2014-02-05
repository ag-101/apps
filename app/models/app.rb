class App < ActiveRecord::Base
  attr_accessible :app_type, :created_by_id, :description, :name, :updated_by_id

  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"   

  has_many :homes, :dependent => :destroy
  has_many :roles, :dependent => :destroy
  belongs_to :user
  
  has_many :constructs, :dependent => :destroy
  
  validates :name, length: { minimum: 2 }, presence: true, uniqueness: true
  validates :app_type, presence: true


end
