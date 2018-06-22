require 'test_helper'

class TransactionInterfaceTest < ActiveSupport::TestCase
  class TransferValueTest < TransactionInterfaceTest
    setup do
      @transaction = TransactionInterface.new
    end

    test  "0" do
      assert @transaction.transfer_value("0"), "0"
    end

    test "1" do
      assert @transaction.transfer_value("1"), "1" + "0" * 18
    end

    test "1.23" do
      assert @transaction.transfer_value("1.23"), "123" + "0" * 16
    end

    test "0.2" do
      assert @transaction.transfer_value("0.2"), "2" + "0" * 17
    end
  end
end
