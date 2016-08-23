module Bank
	class Account
		attr_accessor :ID, :balance, :owner
		
		def initialize(ID, balance=0, owner=nil)
			if balance < 0
				raise ArgumentError.new
			end

			@ID = ID
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
	end

	class Owner
		attr_accessor :name, :address
		def initialize(name, address)
			@name = name
			@address = address
		end
	end
end