module EndUserValidation
  extend Themis::Validation

  validates_presence_of :username, :password, :email
  validates :password, length: { minimum: 6 }
  validates :email, email: true
end
