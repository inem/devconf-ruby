class RedeemBonuscode
  def run!(hashcode, recipient_id)
    raise BonuscodeNotFound.new unless bonuscode = find_bonuscode(hashcode)
    raise RecipientNotFound.new unless recipient = find_recipient(recipient_id)
    raise BonuscodeIsAlreadyUsed.new if bonuscode.used?
    raise IncorrectRecipientType.new unless correct_user_type?(recipient.type)

    ActiveRecord::Base.transaction do
      amount = bonuscode.redeem!(recipient_id)
      recipient.increase_balance!(amount)

      recipient.save! && bonuscode.save!
      recipient.balance
    end
  end

  private

  def find_bonuscode(hashcode)
    Bonuscode.find_by_hash(hashcode)
  end

  def find_recipient(id)
    User.find_by_id(id)
  end

  def correct_user_type?(user_type)
    ['regular', 'paying'].include?(user_type)
  end
end
