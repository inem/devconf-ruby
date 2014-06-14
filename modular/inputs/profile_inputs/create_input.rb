module ProfileInputs
  class CreateInput < Input
    attribute :image_id, Integer, default: nil
    attribute :gender, String
    attribute :username, String
    attribute :description, String
    attribute :age, Integer

    validates :gender, presence: true, inclusion: GENDER_OPTIONS
    validates :username, presence: true, length: { minimum: 4 }
    validates :image_id, numericality: { only_integer: true }, allow_nil: true
    validates :age, numericality: { only_integer: true }, allow_nil: true

    def initialize(*args)
      super(*args)
      @image_id = nil if @image_id == ""
    end
  end
end