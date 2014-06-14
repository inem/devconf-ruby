collection @object
attribute :id, :deleted, :username, :age

node :gender do |object|
  object.gender.to_s
end

node :thumbnail_image_url do |obj|
  obj.thumbnail_image.asset.url
end

node :standard_image_url do |obj|
  obj.standard_image.asset.url
end
