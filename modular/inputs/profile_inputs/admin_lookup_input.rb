module ProfileInputs
  class AdminLookupInput < Input
    attribute :profile_ids, Array[Integer]
    attribute :user_ids, Array[Integer]
    attribute :is_deleted, Boolean

    validate do |input|
      if profile_ids.blank? && user_ids.blank?
        errors.add_to_base "profile ids or user ids should be provided"
      end
    end

    validate do |input|
      if !profile_ids.blank? && !user_ids.blank?
        errors.add_to_base "provide only user_ids or profile_ids"
      end
    end

    def prepare_ids
      if user_ids.blank?
        profile_ids
      elsif profile_ids.blank?
        ProfileRepo.find_by_user_ids(user_ids).map(&:id)
      end
    end
  end
end