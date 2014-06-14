class ProfileRepo
  class UnknownProperty < StandardError
    def initialize(property)
      @property = property
    end

    def to_s
      "Unknown #{@property}"
    end
  end

  class << self
    def table
      DB[:profile]
    end

    def find id
      to_add = [:gender__name___gender, :profile_status__name___status,
                :picture_id___image_id]

      dataset = table.join(:online_profile_status, id: :online_profile_status_id)
                     .join(:gender, id: :profile__gender_id)
                     .select_all(:profile)
                     .select_append(*to_add)
                     .where(profile__id: id)

      all = dataset.all.map do |record|
        Profile.new(record)
      end

      all.size > 1 ? all : all.first
    end

    def persist(profile)
      status_id = DB[:online_profile_status].select(:id).where(name: profile.status).get(:id)
      raise UnknownProperty.new(:status) unless status_id

      gender_id = DB[:gender].select(:id).where(name: profile.gender).get(:id)
      raise UnknownProperty.new(:gender) unless gender_id

      hash = { username: profile.username,
               user_id: profile.user_id,
               deleted: profile.deleted,
               profile_status_id: status_id,
               gender_id: gender_id,
               picture_id: profile.image_id
             }

      if profile.new_record?
        dates = { date_created: Time.now.utc,
                  last_updated: Time.now.utc }
        profile.id = table.insert(hash.merge! dates)
      else
        table.where(id: profile.id).update(hash)
      end
    end
  end
end