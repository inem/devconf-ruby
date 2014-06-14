class CreateBonuscode
  class AdminRoleRequired < StandardError; end

  def initialize(input, requester)
    @input, @requester = input, requester
  end

  def run!
    @input.validate!
    authorize!

    Bonuscode.create_many(@input.coins, @input.number)
  end

  def authorize!
    unless @requester && @requester.roles_array.include?('ROLE_ADMIN')
      fail AdminRoleRequired.new
    end
  end
end