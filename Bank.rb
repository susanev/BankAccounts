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
				accounts.push(create_account(line))
			end
			return accounts
		end

		def self.find(id)
			CSV.open("support/accounts.csv", "r").each do |line|
				if line[0].to_i == id
					return create_account(line)
				end
			end
			return nil
		end

		def self.create_account(line)
			return Bank::Account.new(line[0].to_i, line[1].to_i)
		end
	end

	class Owner
		attr_accessor :id, :name, :address, :accounts
		
		def initialize(id, l_name, f_name, street_address, city, state)
			@id = id
			@name = "#{f_name} #{l_name}"
			@address = "#{street_address} \n #{city}, #{state}"
			@accounts = nil
		end

		def self.all
			owners = []
			CSV.open("support/owners.csv", "r").each do |line|
				owners.push(create_owner(line))
			end
			return owners
		end

		def self.find(id)
			CSV.open("support/owners.csv", "r").each do |line|
				if line[0].to_i == id
					return create_owner(line)
				end
			end
			return nil
		end

		def self.create_owner(line)
			return Bank::Owner.new(line[0], line[1], line[2], line[3], line[4], line[5])
		end

		def accounts(owner, file)
			accounts = []
			CSV.open("support/account_owners.csv", "r").each do |line|
				if line[1] == owner.id
					accounts.push(Bank::Account.new(line[0]))
				end
			end
			return accounts
		end
	end
end






