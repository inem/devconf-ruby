module SubscriberValidation
  extend Themis::Validation

  validates :email, email: true
end
