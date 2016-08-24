gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'
require 'minitest/pride'
require_relative 'Bank'

class BankTest < Minitest::Test

	def test_account_no_owner
		acct = Bank::Account.new(13, 1400)

		assert_equal acct.id, 13
		assert_equal acct.balance, 1400
		assert_equal acct.owner, nil
	end

	def test_account_owner
		owner = Bank::Owner.new("susan", "123street")
		acct = Bank::Account.new(13, 1400, owner)

		assert_equal acct.id, 13
		assert_equal acct.balance, 1400
		assert_equal acct.owner, owner
	end

	def test_withdraw
		acct = Bank::Account.new(13, 1400)
		
		acct.withdraw(500)
		assert_equal acct.balance, 900

		acct.withdraw(100000)
		assert_equal acct.balance, 900
	end

	def test_deposit
		acct = Bank::Account.new(13, 1400)

		acct.deposit(5000)
		assert_equal acct.balance, 6400
	end

	def test_csv_all
		assert_equal Bank::Account.all.length, 12
		assert_equal Bank::Account.all[2].id, 1214
		assert_equal Bank::Account.all[6].balance, 9844567
	end

	def test_csv_find
		assert_equal Bank::Account.find(15156).balance, 4356772
	end
end