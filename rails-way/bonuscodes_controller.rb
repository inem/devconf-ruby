...
  def redeem
    unless bonuscode = Bonuscode.find_by_hash(params[:code])
      render json: {error: 'Bonuscode not found'}, status: 404 and return
    end
    unless recipient = User.find_by_id(params[:receptor_id])
      render json: {error: 'Recipient not found'}, status: 404 and return
    end
    if bonuscode.used?
      render json: {error: 'Bonuscode is already used'}, status: 404 and return
    end
    unless ['regular', 'paying'].include?(recipient.type)
      render json: {error: 'Incorrect user type'}, status: 404 and return
    end

    ActiveRecord::Base.transaction do
      amount = bonuscode.mark_as_used!(params[:receptor_id])
      recipient.increase_balance!(amount)

      if recipient.save && bonuscode.save
        render json: {balance: recipient.balance}, status: 200 and return
      else
        render json: {error: 'Error during transaction'}, status: 500 and return
      end
    end
  end
...