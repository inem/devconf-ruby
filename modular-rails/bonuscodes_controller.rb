class API::V1::BonuscodesController < ApplicationController
  def create
    input = BonuscodeCreationInput.new(bonuscode_params)
    use_case = CreateBonuscode.new(input, current_user)
    begin
      bonuscodes = use_case.run!
    rescue Input::ValidationError
      deliver 801, {errors: input.errors, error: 'Invalid parameters'} and return
    rescue CreateBonuscode::AdminRoleRequired
      deliver 403, {error: 'You do not have admin role'} and return
    end
    deliver 201, bonuscodes, 'codes/index'
  end

  def redeem
    use_case = RedeemBonuscode.new

    begin
      recipient_balance = use_case.run!(params[:code], params[:receptor_id])
    rescue BonuscodeNotFound, BonuscodeIsAlreadyUsed, RecipientNotFound => ex
      render json: {error: ex.message}, status: 404 and return
    rescue IncorrectRecipientType => ex
      render json: {error: ex.message}, status: 403 and return
    rescue TransactionError => ex
      render json: {error: ex.message}, status: 500 and return
    end

    deliver 201, {balance: recipient_balance}
  end

  def status
    unless bonuscode = Bonuscode.find_by_hash(params[:code])
      deliver 404, {error: 'Bonuscode was not found'} and return
    end
    deliver 201, {status: 'Bonuscode is already used'} and return if bonuscode.used?
    deliver 201, {status: 'Bonuscode is valid'}
  end

  private

  def bonuscode_params
    params.permit(:coins, :number)
  end
end
