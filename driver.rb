require_relative 'item'
require_relative 'querycraigslist'
require_relative 'dictcreator'

data = Array.new
filtered_titles = Array.new
bad_titles = Array.new
file_arr = Array.new

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

if (File.exist?("#{search}dict.txt"))
	File.open("#{search}dict.txt", 'r') do |file|
		file.each_line do |line|
			data.delete_if{|i| i.title.downcase.include? line.chomp}
		end
	end
end



data.each_with_index do |m, index|
	puts "#{index} : #{m.title} : #{m.price}"
	ac += m.price
end

puts "Do you want to filter the search results? (yes/no)"

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

else
	puts "The average price is: $#{ac/data.length}"
end
	
