#encoding: utf-8

require_relative './url_builder'
require_relative './html_parser'
require_relative './auction_parser'
require_relative './abstract_client'

class SampleClient < AbstractClient

	def initialize(*search_param)
		builder = URLBuilder.new
		builder.set_params(
			page: 1,
			order: :desc,
			sort: :bid_count
		)
		builder.set_search_words(*search_param)
		
		url = builder.build_url

		doc = HTMLParser.get_doc url
		@list = AuctionParser.create_list doc
	end

	def get_avr
		return @list.map(&:end_price).inject(0, &:+).to_f / @list.length
	end

	def dump
		@list.each do |e|
			puts e.inspect
		end
	end
end

