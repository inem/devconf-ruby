class UserRepo
  class << self
    def defaults
      {
        account_expired: false,
        account_locked: false,
        enabled: true
      }
    end

    def table
      DB[:user]
    end

    def username_exist?(username)
      table.where(username: username).count == 1
    end

    def find(id)
      dataset = table.select(:id, :username, :enabled, :date_created, :last_updated).where(id: id)
      user = User.new(dataset.first)
      user.roles = get_roles(id)
      user
    end

    def persist(user)
      hash = {username: user.username}
      hash.merge! defaults

      begin
        user.id = table.insert(hash)
      rescue Sequel::UniqueConstraintViolation => e
        raise SqlError.new(e.message)
      end
    end

    def delete(user)
      table.where(id: user.id).update(enabled: false)
      user.enabled = false
    end

    private

    def get_roles(user_id)
      DB[:role].select(:authority).join(:user_role, user_role__role_id: :role__id)
               .where(user_role__user_id: user_id).map{|r| r[:authority]}
    end

  end
end
