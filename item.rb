#Author: Eric Fridrich
#Description: This class creates and Item object which accepts a title an a price as arguments

class Item
	def initialize(title, price)
		@title = title
		@price = price
	end
	
	attr_accessor :title
	attr_accessor :price
end 


