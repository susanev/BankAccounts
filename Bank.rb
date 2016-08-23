module Bank
	class Account
		attr_accessor :ID, :balance
		
		def initialize(ID, balance=0)
			if balance < 0
				raise ArgumentError.new
			end

			@ID = ID
			@balance = balance
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
end