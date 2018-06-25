class AddressesController < ApplicationController
  # GET /addresses/new
  def new
    @address = Address.new
  end

  # POST /addresses
  def create
    addr = params.dig(:address, :addr)
    # STEP_1 check verification code
    # STEP_2 check address info
    unless TransactionInterface.is_address(addr)
      # address is error
      flash[:error] = "address is wrong"
      return render :new
    end
    # STEP_3 save address
    @address = Address.create(address_param)
    # STEP_4 send a transaction to chain
    value = "100"
    @transaction_interface = TransactionInterface.new
    _hash, _state = @transaction_interface.send_transaction(addr, value)
    # STEP_5 notify frontend
    flash[:success] = "send success"
    redirect_to new_address_path
  end

  private

  def address_param
    params.require(:address).permit(:addr)
  end

end
