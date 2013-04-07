#Author: Eric Fridrich
#Description: This class creates a bad words dictionary based on the filtered rtitles and the bad titles
#the bad words are determined by any word in the bad titles which are not in the filtered(good) titles
#numbers are excluded.

class DictCreator
	def initialize(filtered, bad, search)
		@filtered = filtered
		@bad = bad
		@search = search
	end
	
	def create_dict
		@filtered_words = @filtered.join(" ").downcase.split(/\W/i).uniq.select{|w| w.length > 2}
		@bad_words = @bad.join(" ").downcase.split(/\W/i).uniq.select{|w| w.length > 2}
		@dict_words = (@bad_words - @filtered_words)
		@dict_words.reject!{|i| i =~ /\A\d+\z/}
		File.open("#{@search}dict.txt" , 'a') do |file|
				file.puts @dict_words
		end
	end
end
