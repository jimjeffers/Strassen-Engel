class Article < ActiveRecord::Base
  require RAILS_ROOT+'/lib/paperclip_processors/jcropper.rb'
  AVATAR_SW = (295/2.5).to_i
  AVATAR_SH = (220/2.5).to_i
  AVATAR_NW = 295
  AVATAR_NH = 220
  
  has_attached_file :avatar,
        :styles => { :normal => ["#{AVATAR_NW}x#{AVATAR_NH}>", :jpg],
                     :small => ["#{AVATAR_SW}x#{AVATAR_SH}#", :jpg] },
        :processors => [:jcropper],
        :default_url => "/images/default_avatar.png"

  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']
  
  after_update :reprocess_avatar, :if => :cropping?
  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
    
  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file avatar.path(style)
  end
  
  private
  
  def reprocess_avatar
    avatar.reprocess!
  end

end
