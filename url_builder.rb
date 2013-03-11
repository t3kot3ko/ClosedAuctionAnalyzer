require 'uri'

# URLBuilder
# パースの対象となる URL を与えられたパラメータに基いて生成します

class URLBuilder
	BASE_URL = "http://closedsearch.auctions.yahoo.co.jp/jp/"

	KEY_PAIR = {
		page: :apg,
		sort: :s1,
		order: :o1,
		min_price: :aucminprice,
		max_price: :aucmaxprice,
		from: :abtach
	}

	VALUE_PAIR = {
		order: {
			asc: "a",
			desc: "d"
		},
		sort: {
			start_price: "sbids",
			end_price: "cbids",
			bid_count: "bids",
			end_time: "end"
		},
		from: {
			store: "1",
			all: "0"
		}
	}

	def initialize
		@params = {}
	end

	def build_url
		raise "Search words not specified" unless @search_words
		
		search_words_str = @search_words.map{|e| URI.encode e.encode("EUC-JP")}.join("+")
		param_str = build_params_str(@params)
		return BASE_URL + "closedsearch?p=#{search_words_str}#{param_str}"
	end

	def set_search_words(*search_words)
		@search_words = search_words.to_ary
	end

	def set_params(in_params = {})
		in_params.each do |k, v|
			if KEY_PAIR[k].nil?
				raise "Illegal parameter"
			end
			
			if VALUE_PAIR[k] && VALUE_PAIR[k][v].nil?
				raise "Illegal parameter"
			end
			
			@params[KEY_PAIR[k]] = VALUE_PAIR[k] ? VALUE_PAIR[k][v] : v
		end
	end

	private
	# パラメータハッシュを key = value にして & でつなげる
	def build_params_str(hash)
		valid_params = hash.select{|k, v| !v.nil?}
		
		if valid_params.empty?
			return ""
		end
		
		return "&" + valid_params.map{|k, v| "#{k}=#{v}"}.join("&")
	end
end


