#encoding: utf-8

require_relative './url_builder'
require_relative './html_parser'
require_relative './auction_parser'
require_relative './abstract_client'

class SampleClient < AbstractClient

	def initialize(*search_param)
		@builder = URLBuilder.new
		@page = 1
		
		self.set_params(
			{
				page: @page,
				order: :desc,
				sort: :end_price
			}
		)
		self.set_search_words(*search_param)
		
		update
	end

	def set_params(params)
		@builder.set_params params
	end

	def set_search_words(*search_words)
		@builder.set_params(page: 1)
		@builder.set_search_words(*search_words)
	end

	def update
		url = @builder.build_url
		puts url
		@doc = HTMLParser.get_doc url
		@list = AuctionParser.create_list @doc
	end

	def append
		url = @builder.build_url
		@doc = HTMLParser.get_doc url
		@list += AuctionParser.create_list @doc
	end


	def get_avr
		return @list.map(&:end_price).inject(0, &:+).to_f / @list.length
	end

	def dump
		@list.each do |e|
			puts e.inspect
		end
	end

	def has_next_page?
		tables = @doc.css("#list01").xpath(".//table")
		return false if tables.empty?
		
		tables.select do |t|
			tds = t.xpath(".//td")
			if tds.length == 2 && tds.any?{|td| td.key?("align") && td["align"] == "right"}
				tds.last.xpath(".//a").first.text =~ /(前|次)の50件/
			else
				false
			end
		end.length == 1
	end

	def append_next_page
		@page += 1
		self.set_params(page: @page)
		self.append
	end
end


