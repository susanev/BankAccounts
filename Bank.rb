module Bank
	class Account
		attr_accessor :ID, :balance
		
		def initialize(ID, balance=0)
			@ID = ID
			@balance = balance
		end
	end
end