class User < ActiveRecord::Base
  self.table_name = 'user'
  has_one :user_status
  belongs_to :account_type, foreign_key: :account_typ_id
  has_many :profiles

  has_and_belongs_to_many :roles, join_table: 'user_role'

  validates_uniqueness_of :email, allow_nil: true
  validates_uniqueness_of :username, allow_nil: true

  has_validation :admin, AdminValidation
  has_validation :enduser, EndUserValidation
  has_validation :subscriber, SubscriberValidation

  def increase_balance!(amount)
    user_status.update_attributes(balance: balance + amount)
  end

  def type
    account_type.name
  end

  def roles_array
    roles.map(&:authority)
  end
end
