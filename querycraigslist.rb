require 'nokogiri'
require 'open-uri'

class QueryCraigsList
	def initialize(location, searchTerm)
		@location = location
		@searchTerm = searchTerm
		@query = Nokogiri::HTML(open("http://#{@location}.craigslist.org/search/?areaID=41&subAreaID=&query=#{@searchTerm}&catAbb=sss"))
	end
	
	attr_accessor :location, :searchTerm, :query
	
end




