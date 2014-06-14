class UsernameInput < Input
  attribute :username, String
  validates :username, length: {minimum: 4}

  validate do
    if username =~ /^\s/ || username =~ /\s$/
      errors.add :username, "should not contain leading and tailing white spaces"
    end
  end
end
