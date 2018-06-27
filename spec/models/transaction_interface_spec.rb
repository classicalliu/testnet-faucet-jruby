require 'rails_helper'

RSpec.describe TransactionInterface, type: :model do
  context "transfer value test" do
    let(:transaction) { TransactionInterface.new }

    it "0" do
      expect(transaction.transfer_value "0").to eq "0"
    end

    it "1" do
      expect(transaction.transfer_value "1" ).to eq ("1" + "0" * 18)
    end

    it "1.23" do
      expect(transaction.transfer_value "1.23").to eq ("123" + "0" * 16)
    end

    it "0.2" do
      expect(transaction.transfer_value "0.2").to eq ("2" + "0" * 17)
    end
  end
end
