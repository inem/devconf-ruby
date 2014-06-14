module AdminValidation
  extend Themis::Validation

  validates_presence_of :username, :password, :email, :surname, :forename,
                        :street, :streetnumber# , plz, ...
  validates :password, length: { minimum: 8 }
  validates :email, email: true
end