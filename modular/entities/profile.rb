class Profile < Entity
  attribute :id, Integer
  attribute :user_id, Integer
  attribute :username, String
  attribute :age, Integer
  attribute :description, String
  attribute :deleted, Bitfield, default: false
  attribute :is_online, Bitfield, default: false

  attribute :gender, String
  attribute :status, String

  attribute :image_id, Integer
  attribute :image, 'Image'
end