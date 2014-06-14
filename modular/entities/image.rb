class Image < Entity
  attribute :thumbnail_url, String
  attribute :profile_url, String
  attribute :approved, Boolean

  def approved?
    approved
  end
end