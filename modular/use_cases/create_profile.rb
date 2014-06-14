class UsernameBusy < StandardError; end
class MaximumNumberOfProfilesReached < StandardError; end

class CreateProfile
  attr_reader :input_class

  def initialize(creator, input_class = ProfileInputs::CreateInput)
    @creator = creator
    @input_class = input_class
  end

  def run!(params)
    input = @input_class.new(params)
    input.validate!

    raise UsernameBusy.new unless username_available?(params)
    profile = nil

    DB.transaction do
      profile = Profile.new(input.params.merge!(user_id: @creator.id))

      profile.image = ImageRepo.find(profile.image_id) if profile.image_id
      ProfileRepo.persist profile
    end

    profile
  end

  private

  def username_available?(params)
    CheckUsernameAvailability.new.run! params
  end
end