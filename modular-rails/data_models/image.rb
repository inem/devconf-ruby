class Image < DataModel
  self.table_name = 'image'
  has_and_belongs_to_many :image_variants, join_table: "image_image", class_name: "Image", association_foreign_key: :image_images_id
  belongs_to :settings, foreign_key: :settings_id, class_name: 'ImageSettings'
  belongs_to :asset
end
