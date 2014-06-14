class ProfilesApi < Sinatra::Base
  helpers Sinatra::JSON

  get '/username/:username' do
    use_case = CheckUsernameAvailability.new
    begin
      availability = use_case.run! params
    rescue Input::ValidationError
      status 801
      json errors: input.errors, error: 'Invalid parameters'
    end
    status 201
    json(data: { available: availability })
  end

  post '/profile/query' do
    input = ProfileInputs::LookupInput.new(params)
    input.validate!

    begin
      profiles = ProfileRepo.find input.prepare_ids
    rescue RecordNotFound
      halt 404
    end

    status 201
    wrapped_profiles = ProfilePresenter.wrap!(profiles, current_user)
    json(data: wrapped_profiles)
  end

  post '/profile' do
    begin
      use_case = CreateProfile.new(current_user)
      profile = use_case.run!(params)
    rescue Input::ValidationError => ex
      halt 403
    end

    wrapped_profiles = ProfilePresenter.wrap!([profile], current_user)
    json(data: wrapped_profiles)
  end
end
