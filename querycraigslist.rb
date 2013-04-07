#Author: Eric Fridrich
#Description: This class creates a QueryCraigsList object this object takes a location and a search term as an argument.
#Uses location and search term to query Craigslist, the query variable equals the returned html from the query.
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




