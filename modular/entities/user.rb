class User < Entity
  attribute :id, Integer
  attribute :username, String
  attribute :enabled, Boolean, default: true

  attribute :profiles, Array[Profile]
  attribute :roles, Array

  def admin?
    @roles.include? 'ROLE_ADMIN'
  end

  def owner?(object)
    object.user_id == id
  end
end
