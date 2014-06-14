class ProfilePresenter
  attr_reader p, viewer

  def initialize(profile, viewer)
    @p, @viewer = profile, viewer
  end

  def wrap!
    hash = {
      id:            p.id,
      deleted:       p.deleted,
      username:      p.username,
      is_online:     p.is_online,
    }
    hash[:user_id] = p.user_id       if viewer.admin?
    hash[:image]   = p.image.to_hash if add_image?
    hash
  end

  def self.wrap!(profiles, viewer)
    profiles.map do |profile|
      new(profile, viewer).wrap!
    end
  end
...
end