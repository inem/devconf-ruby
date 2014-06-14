class CheckUsernameAvailability
  attr_reader :input_class

  def initialize(input_class = UsernameInput)
    @lookup_classes = [ProfileRepo, UserRepo]
    @input_class = input_class
  end

  def run!(params)
    input = @input_class.new params
    input.validate!

    @lookup_classes.each do |klass|
      return false if klass.username_exist?(input.username)
    end
    return true
  end
end
