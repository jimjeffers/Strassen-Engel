class District < ActiveRecord::Base
  has_many :articles, :counter_cache => true
  
  scope :sorted, :order => "name ASC", :include => :articles
end
