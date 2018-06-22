require "java"
require "web3j-3.3.1-full.jar"

java_import org.web3j.protocol.Web3j
java_import org.web3j.protocol.core.DefaultBlockParameter
java_import org.web3j.protocol.core.methods.request.Call
java_import org.web3j.protocol.core.methods.request.Transaction
java_import org.web3j.protocol.core.methods.response.TransactionReceipt
java_import org.web3j.protocol.http.HttpService
JavaNumeric = org.web3j.utils.Numeric

java_import java.math.BigInteger
JavaRandom = java.util.Random
JavaSystem = java.lang.System
JavaMath = java.lang.Math

class TransactionInterface
  VERSION = 0

  def initialize
    @cita_url = ENV["CITA_URL"]
    @private_key = ENV["PRIVATE_KEY"]

    HttpService.setDebug(true) unless Rails.env.production?
    @service = Web3j.build(HttpService.new(@cita_url))
    @random = JavaRandom.new(JavaSystem.currentTimeMillis())
    @chain_id = 1
  end

  def current_block_number
    @service.ethBlockNumber().send().getBlockNumber() # .longValue()
  end

  # value = "1" + "0" * 18 means 1 nos
  def send_transaction(address, value = "0")
    current_height = current_block_number

    valid_until_block = current_height + 80
    nonce = BigInteger.valueOf(JavaMath.abs(@random.nextLong()))
    quota = 1_000_000
    tx = Transaction.createFunctionCallTransaction(address, nonce, quota, valid_until_block, VERSION, @chain_id, transfer_value(value), "")
    raw_tx = tx.sign(@private_key, false, false)
    result = @service.ethSendRawTransaction(raw_tx).send().getSendTransactionResult()
    status = result.getStatus()
    hash = result.getHash()

    [hash, status]
  end

  def transfer_value(value)
    (value.to_d * (10 ** 18)).to_i.to_s
  end

end
