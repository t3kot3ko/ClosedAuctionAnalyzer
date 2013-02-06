class Entity
	attr_reader :url, :name, :start_price, :end_price, :bid_count, :end_time
	attr_reader :properties

	def initialize(url, name, start_price, end_price, bid_count, end_time)
		@url = url
		@name = name
		@start_price = start_price
		@end_price = end_price
		@bid_count = bid_count
		@end_time = end_time
	end
end

