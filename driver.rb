#Author: Eric Fridrich
#Desciption: This program will search craigslist and retrun the search results along with the average price to the user
#It allows the user to filter their search results
#If the user runs the same query again similar results will automatically be filtered out
#Troubleshooting: If no results are returned on a query there might not be anything on craigslist matching your serach
#or your dictionary has words in it causing all results to be filtered out automatically, so you may need to manually remove some
#words from the dictonary file.

require_relative 'item'
require_relative 'querycraigslist'
require_relative 'dictcreator'

data = Array.new
filtered_titles = Array.new
bad_titles = Array.new
file_arr = Array.new

#Prompts the user for a location
puts "Where do you want to search? (must enter a valid craigslist city)"
location = gets.chomp
#Prompts the user for a search term
puts "What do you want to search for?"
search = gets.chomp
#Allows the user the supply a minimum price
puts "Set a min price above 0 for your item"
minPrice = gets.chomp.to_i

#Adds a + sign between words in the search term to help create a valid url
searchTerm = search.gsub(/\s+/,'+')

#Creates a QueryCraigsList object with user supplied location and search term
result = QueryCraigsList.new(location,searchTerm)

#Puts the title and price into an array of Item object's called data
result.query.css('p').each do |n|

	price = n.css('span.itempp').text
	price.slice!("$")
	price = price.to_i
	
	if(n.css('a').to_s.downcase.include?(search) and price > minPrice)
		item = n.css('a')[0].text.gsub(/[^\w ]/i,'')
		data << Item.new(item, price)
	end 
	
end

#sets up ac as an accumlator for the price
ac = 0

#checks if a bad words dictionary exists for the current search term
if (File.exist?("#{search}dict.txt"))
	File.open("#{search}dict.txt", 'r') do |file|
		file.each_line do |line|
			data.delete_if{|i| i.title.downcase.include? line.chomp}
		end
	end
end

#Displays the item and price data from the query
#Accumulates the prices
data.each_with_index do |m, index|
	puts "#{index} : #{m.title} : #{m.price}"
	ac += m.price
end

#Asks the user if they want to filter the results further
puts "Do you want to filter the search results? (yes/no)"

#If the user chooses to filter the results the following happens:
#	A bad results array is created which contains the objects that need to be filtered
#	A filtered results array is created which contains the objects in the data array that arent in the bad results array
# 	A filtered titles array is created which contains only the title information
# 	A bad titles array is created which contains only the bad title information
# 	The filtered and bad titles array is sent to the dictcreator class and a dictonary of bad words for the serach term is created
#	The new filtered results are displayed on screen along with the average price
if (gets.chomp != 'no')
	puts "Type the line number followed by a space to filter search results"
	bad_results = gets.chomp.split(' ').map{ |value| data[value.to_i]}
	filtered_results = data - bad_results
	filtered_results.each_index{|a| filtered_titles << filtered_results[a].title}
	bad_results.each_index{|b| bad_titles << bad_results[b].title}
	dict = DictCreator.new(filtered_titles, bad_titles, search)	
	dict.create_dict
	puts "The new results are:"
	ac = 0
	filter_results.each do |i| 
		puts "#{i.title} : #{i.price}"
		ac += i.price
	end
	puts "The average price is: $#{ac/filtered_results.length}"

else #if the results did not need to be filtered then the average is dispalyed
	puts "The average price is: $#{ac/data.length}"
end
	
