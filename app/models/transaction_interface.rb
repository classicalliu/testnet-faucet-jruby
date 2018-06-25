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
    transferred_value = transfer_value(value)
    tx = Transaction.createFunctionCallTransaction(address, nonce, quota, valid_until_block, VERSION, @chain_id, transferred_value, "")
    raw_tx = tx.sign(@private_key, false, false)
    result = @service.ethSendRawTransaction(raw_tx).send().getSendTransactionResult()
    status = result.getStatus()
    hash = result.getHash()

    [hash, status]
  end

  def transfer_value(value)
    (value.to_d * (10 ** 18)).to_i.to_s
  end

  class << self
    def is_address(address)
      if /^(0x)?[0-9a-f]{40}$/i !~ address
        false
      elsif /^(0x)?[0-9a-f]{40}$/ =~ address || /^(0x)?[0-9A-F]{40}$/ =~ address
        true
      else
        is_checksum_address(address)
      end
    end

    def is_checksum_address(address)
      address_value = address.sub(/^0x/i,'')
      address_hash = sha3(address_value.downcase).sub(/^0x/i, '')
      (0...40).each do |i|
        if (address_hash[i].to_i(16) > 7 && address_value[i].upcase != address_value[i]) || (address_hash[i].to_i(16) <= 7 && address_value[i].downcase != address_value[i])
          return false
        end
      end
      true
    end

    SHA3_NULL_S = '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
    def sha3(value)
      if is_hex_strict(value) && /^0x/i =~ value.to_s
        value = hex_to_bytes(value)
      end

      return_value = "0x" + Digest::SHA3.hexdigest(value, 256)

      if return_value == SHA3_NULL_S
        nil
      else
        return_value
      end
    end

    def hex_to_bytes(hex)
      hex = hex.to_s(16)
      raise "Given value #{hex} is not a valid hex string" unless is_hex_strict(hex)
      hex_value = hex.sub(/^0x/i, '')
      (0...hex_value.size).step(2).map {|c| hex_value[c, 2].to_i(16) }
    end

    def is_hex_strict(hex)
      (hex.is_a?(String) || hex.is_a?(Numeric)) && /^(-)?0x[0-9a-f]*$/i =~ hex
    end
  end

end
