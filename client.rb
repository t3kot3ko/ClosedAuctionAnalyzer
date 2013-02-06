#encoding: utf-8

require_relative './url_builder'
require_relative './html_parser'
require_relative './auction_parser'

builder = URLBuilder.new
builder.set_params(page: 1)
builder.set_search_words("l-04d", "新品")
url = builder.build_url

puts url

doc = HTMLParser.get_doc url
list = AuctionParser.create_list doc

list.each do |e|
	puts e.inspect
end

