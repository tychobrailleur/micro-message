require 'sinatra'
require 'nokogiri'
require 'ruleby'

set :port, 9495


class Transaction
  def initialize(code)
    @code = code
  end

  attr :code, true
end

class TransactionRulebook < Ruleby::Rulebook
  def rules
    rule [Transaction, :t, m.code == 42] do |context|
      puts "TRANSACTION: #{context[:t].code}"
    end

    rule [Transaction, :t, m.code == 23] do |context|
      puts "BINGO!!!"
    end
  end
end

include Ruleby

post '/process' do
  req = request.body.read
  doc = Nokogiri::XML(req)
  code = doc.at_xpath('/code').text()

  txn = Transaction.new(code.to_i)

  # Pass transaction to rule engine and try to match.
  # Do we need to create a new instance every time?
  engine :engine do |e|
    TransactionRulebook.new(e).rules
    e.assert txn
    e.match
  end
end
