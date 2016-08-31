gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'
require 'minitest/pride'
require_relative 'Bank'

class BankTest < Minitest::Test

	def test_account_no_owner
		acct = Bank::Account.new(13, 1400)

		assert_equal 13, acct.id
		assert_equal 1400, acct.balance
		assert_equal nil, acct.owner
	end

	def test_account_owner
		owner = Bank::Owner.new("1", "ev", "susan", "123street", "seattle", "wa")
		acct = Bank::Account.new(13, 1400, owner)

		assert_equal 13, acct.id
		assert_equal 1400, acct.balance
		assert_equal owner, acct.owner
	end

	def test_withdraw
		acct = Bank::Account.new(13, 1400)
		
		acct.withdraw(500)
		assert_equal 900, acct.balance

		acct.withdraw(100000)
		assert_equal 900, acct.balance
	end

	def test_deposit
		acct = Bank::Account.new(13, 1400)

		acct.deposit(5000)
		assert_equal 6400, acct.balance
	end

	def test_account_csv_all
		accounts = Bank::Account.all
		assert_equal 12, accounts.length
		assert_equal 1214, accounts[2].id
		assert_equal 9844567, accounts[6].balance
	end

	def test_account_csv_find
		assert_equal 4356772, Bank::Account.find(15156).balance
		assert_equal nil, Bank::Account.find(0)
	end

	def test_owner_csv_all
		owners = Bank::Owner.all
		assert_equal 12, owners.length
		assert_equal "9 Portage Court\nWinston Salem, North Carolina", owners[2].address
		assert_equal "18", owners[4].id
	end

	def test_owner_csv_find
		assert_equal "Jessica Bell", Bank::Owner.find(21).name
		assert_equal nil, Bank::Owner.find(200)
	end

	def test_owner_accounts
		owner = Bank::Owner.new("25", "ev", "susan", "123street", "seattle", "wa")
		assert_equal 1, owner.accounts("support/account_owners.csv").length
		assert_equal 0, owner.accounts("support/account_owners.csv")[0].balance
	end

	def test_savings_account
		savings_acct = Bank::SavingsAccount.new(25, 0) rescue ArgumentError
		assert_equal ArgumentError, savings_acct

		savings_acct = Bank::SavingsAccount.new(25, 10)
		assert_equal 10, savings_acct.balance

		savings_acct.deposit(100)
		assert_equal 110, savings_acct.balance

		savings_acct.withdraw(50)
		assert_equal 58, savings_acct.balance

		savings_acct.withdraw(50)
		assert_equal 58, savings_acct.balance

		assert_equal savings_acct.add_interest(0.25), 0.145
		assert_equal 58.145, savings_acct.balance

	end

end















