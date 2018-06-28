class AddressesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # POST /addresses
  def create
    addr = params.dig(:address, :addr)
    # STEP_1 check verification code
    @address = Address.new(address_params)
    unless @address.valid_with_captcha?
      flash.now[:captcha] = "captcha is wrong"
      return render :new
    end

    # STEP_2 check address info
    unless TransactionInterface.is_address(addr)
      # address is error
      flash.now[:addr] = "address is wrong"
      return render :new
    end

    # STEP_3 save address
    @address.save

    # STEP_4 send a transaction to chain
    value = ENV.fetch("NOS_VALUE")
    @transaction_interface = TransactionInterface.new
    _hash, _state = @transaction_interface.send_transaction(addr, value)

    # STEP_5 notify frontend
    flash[:success] = "send success"
    redirect_to new_address_path
  end

  private

  def address_params
    patch_params
    params.require(:address).permit(:addr, :captcha, :captcha_key)
  end

  def patch_params
    params[:address][:captcha] = params[:captcha]
    params[:address][:captcha_key] = params[:captcha_key]
  end

end
