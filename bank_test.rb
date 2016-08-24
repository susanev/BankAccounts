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
		owner = Bank::Owner.new("1", "ev", "susan", "123street", "seattle", "wa")
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

	def test_account_csv_all
		accounts = Bank::Account.all
		assert_equal accounts.length, 12
		assert_equal accounts[2].id, 1214
		assert_equal accounts[6].balance, 9844567
	end

	def test_account_csv_find
		assert_equal Bank::Account.find(15156).balance, 4356772
		assert_equal Bank::Account.find(0), nil
	end

	def test_owner_csv_all
		owners = Bank::Owner.all
		assert_equal owners.length, 12
		assert_equal owners[2].address, "9 Portage Court\nWinston Salem, North Carolina"
		assert_equal owners[4].id, "18"
	end

	def test_owner_csv_find
		assert_equal Bank::Owner.find(21).name, "Jessica Bell"
		assert_equal Bank::Owner.find(200), nil
	end

	def test_owner_accounts
		owner = Bank::Owner.new("25", "ev", "susan", "123street", "seattle", "wa")
		assert_equal owner.accounts("support/account_owners.csv").length, 1
		assert_equal owner.accounts("support/account_owners.csv")[0].balance, 0
	end

end















