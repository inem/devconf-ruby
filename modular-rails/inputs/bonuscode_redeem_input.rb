# encoding=utf-8
#
class BonuscodeRedeemInput < Input
  attribute :hash_code, String
  attribute :receptor_id, Integer

  validates_presence_of :hash_code, :receptor_id
  validates_numericality_of :receptor_id

end
