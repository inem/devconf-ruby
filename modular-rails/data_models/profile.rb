class Profile < ActiveRecord::Base
  self.table_name = 'profile'
  belongs_to :gender
  belongs_to :image, foreign_key: :picture_id

  def standard_image
    images.select{|img| img.settings.label == 'Profile'}[0] if images
  end

  def thumbnail_image
    images.select{|img| img.settings.label == 'thumbnail'}[0] if images
  end

  def deleted
    to_boolean(read_attribute('deleted'))
  end

  private
  def images
    [image] + image.image_variants if image
  end
end
