require_relative 'item'
require_relative 'querycraigslist'

data = Array.new

puts "Where do you want to search?"
location = gets.chomp
puts "What do you want to search for?"
search = gets.chomp
puts "Set a min price above 0 for your item"
minPrice = gets.chomp.to_i

searchTerm = search.gsub(/\s+/,'+')

result = QueryCraigsList.new(location,searchTerm)

result.query.css('p').each do |n|

	price = n.css('span.itempp').text
	price.slice!("$")
	price = price.to_i
	
	if(n.css('a').to_s.downcase.include?(search) and price > minPrice)
		item = n.css('a')[0].text.gsub(/[^\w ]/i,'')
		data << Item.new(item, price)
	end 
	
end

ac = 0

#if(exist?("#{search}dict.txt")
	#remove bad results from data array



data.each_with_index do |m, index|
	puts "#{index} : #{m.title} : #{m.price}"
	ac += m.price
end


#do you want to filter results more?
#if(yes)
	#add bad results to dict and remove
puts "The average price is: $#{ac/data.length}"

	
