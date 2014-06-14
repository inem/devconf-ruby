# encoding=utf-8
#
class BonuscodeCreationInput < Input
  attribute :number, Integer
  attribute :coins, Integer

  validates_presence_of :number, :coins
  validates_numericality_of :number, :coins, greater_than: 0

end
