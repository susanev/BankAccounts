module Bank
	class Account
		attr_accessor :ID, :balance
		
		def initialize(ID, balance=0)
			@ID = ID
			@balance = balance
		end

		def withdraw(amount)
			@balance-=amount
			return @balance
		end

		def deposit(amount)
			@balance+=amount
			return @balance
		end
	end
end