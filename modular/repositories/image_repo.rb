class ImageRepo
  class ImageData < Sequel::Model
    set_dataset DB[:image].join(:asset, asset__id: :image__asset_id)
    many_to_many :images, join_table: :image_image, left_key: :image_id, right_key: :image_images_id, class: self
  end

  class << self
    def find(id)
      hash = images_hash(id)
      params = {}

      if hash['Profile']
        params[:approved] = hash['Profile'][:approved]
        params[:profile_url] = hash['Profile'][:url]
      end
      if hash['thumbnail']
        params[:thumbnail_url] = hash['thumbnail'][:url]
      end

      Image.new params
    end

    private
    def images_hash(image_id)
      hash = {}
      images_data(image_id).map do |d|
        asset = DB[:asset].where(id: d.asset_id).first
        settings = DB[:image_settings].where(id: d.settings_id).first
        hash[settings[:label]] = asset
      end
      hash
    end

    def images_data(image_id)
      first = ImageData[image__id: image_id]
      [first, first.images.first].compact
    end
  end
end