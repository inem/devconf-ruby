module ProfileInputs
  class LookupInput < Input
    attribute :profile_ids, Array[Integer]
    validates_presence_of :profile_ids

    def prepare_ids
      profile_ids
    end
  end
end