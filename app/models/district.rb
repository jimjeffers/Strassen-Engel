class District < ActiveRecord::Base
  has_many :articles
  
  validates_uniqueness_of :slug
  validates_presence_of :name
  validates_presence_of :slug
  
  scope :sorted, :order => "name ASC", :include => :articles
end
