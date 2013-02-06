#encoding: utf-8

require_relative './entity'

class AuctionParser
	class << self
		public
		def create_list(doc)
			get_list(doc).map do |e|
				tds = e.xpath(".//td")	
				name = get_name(tds[0])
				url = get_url(tds[0])
				start_price = get_price(tds[1])
				end_price = get_price(tds[2])
				bid_count = get_bid_count(tds[3])
				end_time = get_end_time(tds[4])

				Entity.new(url, name, start_price, end_price, bid_count, end_time)
			end
		end

		def page_num(doc)

		end

		private
		def get_list(doc)
			l = doc.css("#list01").xpath(".//table").last.xpath(".//tr")
			.select{|e| e.xpath(".//td").count > 1} 
			l.shift

			return l
		end

		def get_name(td)
			td.xpath(".//a").first.children.text
		end

		def get_url(td)
			td.xpath(".//a").first.attribute("href").text
		end

		def get_price(td)
			td.text.gsub(",", "").gsub(/\s+円/, "").to_i
		end

		def get_bid_count(td)
			td.text.to_i
		end

		# 日付文字列を抜き取って TIme オブジェクトに変換します
		def get_end_time(td)
			date_str = td.text
			date_reg = /(\d+)月(\d+)日(\d+)時(\d+)分/
			date_ary = date_str.gsub(/\s+/, "").scan(date_reg).first.map(&:to_i)
			return Time.new(2000, *date_ary)
		end

	end
end


