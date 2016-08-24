require 'csv'

module Bank
	class Account
		attr_accessor :id, :balance, :owner
		
		def initialize(id, balance=0, owner=nil)
			if balance < 0
				raise ArgumentError.new
			end

			@id = id
			@balance = balance
			@owner = owner
		end

		def withdraw(amount)
			if(@balance - amount < 0)
				puts "WARNING: You cannot withdraw more than you have"
			else
				@balance-=amount
			end
			return @balance
		end

		def deposit(amount)
			@balance+=amount
			return @balance
		end

		def self.all
			accounts = []
			CSV.open("support/accounts.csv", "r").each do |line|
				accounts.push(Bank::Account.new(line[0].to_i, line[1].to_i))
			end
			return accounts
		end

		def self.find(id)
			acct = nil
			CSV.open("support/accounts.csv", "r").each do |line|
				if line[0].to_i == id
					acct = Bank::Account.new(line[0].to_i, line[1].to_i)
					return acct
				end
			end
			return acct
		end
	end

	class Owner
		attr_accessor :name, :address
		def initialize(name, address)
			@name = name
			@address = address
		end
	end
end