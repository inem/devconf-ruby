class LookupProfiles
  def initialize(input, creator)
    @input = input
    @creator = creator
  end

  def run!
    @input.validate!
    profiles = ProfileRepository.find_by_ids @input.prepare_ids
  end

  private

  #
  def prepare_ids(input)
    input.profile_ids
  end
end
