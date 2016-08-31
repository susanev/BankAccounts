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

		def add_interest(rate)
			interest = @balance * rate/100
			@balance+=interest
			return interest
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
			@address = "#{street_address}\n#{city}, #{state}"
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

		def accounts(file)
			accounts = []
			CSV.open(file, "r").each do |line|
				if line[1] ==id
					accounts.push(Bank::Account.new(line[0]))
				end
			end
			return accounts
		end
	end

	class SavingsAccount < Account
		def initialize (id, balance=0, owner=nil)
			if balance < 10
				raise ArgumentError.new
			end
			super(id, balance, owner)
		end

		def withdraw(amount)
			if(@balance - (amount+2) < 10)
				puts "WARNING: Your balance can not fall below $10"
			else
				puts "A $2 withdraw charge has been deducted from your account"
				@balance-=(amount+2)
			end
			return @balance
		end
	end

	class CheckingAccount < Account
		attr_accessor :checks_used

		def initialize (id, balance=0, owner=nil)
			super(id, balance, owner)
			@checks_used = 0
		end

		def withdraw(amount)
			prev_balance = @balance
			if prev_balance != super(amount+1)
				puts "A $1 withdraw charge is deducted from your account"
			end
			return @balance
		end

		def withdraw_using_check(amount)
			@checks_used < 3 ? fee=0 : fee=2

			if(@balance - (amount+fee) < -10)
				puts "WARNING: Your balance can not fall below -$10"
			else
				@checks_used+=1
				if fee > 0
					puts "A $2 withdraw charge has been deducted from your account"
				end
				@balance-=(amount+fee)
			end
			return @balance
		end

		def reset_checks
			@checks_used = 0
		end
	end

	class MoneyMarketAccount < Account
		attr_accessor :transactions, :transactions_allowed

		def initialize(id, balance=0, owner=nil)
			if balance < 10000
				raise ArgumentError.new
			end

			super(id, balance, owner)

			@transactions = 0
			@transactions_allowed = true
		end

		def withdraw(amount)
			if !@transactions_allowed
				puts "No transactions allowed until you deposit enough to reach or exceed 10000"
				return @balance
			elsif @transactions == 6
				puts "No more transactions allowed this month"
				return @balance
			else
				if @balance - amount < 10000 && @balance - amount >= 0
					puts "Fee of $100 applied for going below 10,000"
					@transactions_allowed = false
					@transactions+=1
					return super(amount+100)
				else
					prev_balance = @balance
					new_balance = super(amount)
					if prev_balance != new_balance
						@transactions+=1
					end
					return new_balance
				end
			end
		end

		def deposit(amount)
			if @transactions == 6
				puts "No more transactions allowed this month"
				return @balance
			elsif @transactions_allowed || @balance + amount >= 10000
				super(amount)

				if !@transactions_allowed
					@transactions_allowed = true
				else
					@transactions+=1
				end
			else
				puts "No transactions allowed until you deposit enough to reach or exceed 10000"
			end

			return @balance
		end

		def reset_transactions
			@transactions = 0
		end
	end
end






