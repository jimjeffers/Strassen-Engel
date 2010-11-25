class District < ActiveRecord::Base
  has_many :articles
  
  scope :sorted, :order => "name ASC", :include => :articles
end
