require 'nokogiri'
require 'open-uri'
require 'nkf'

# 外部ライブラリを用いて，URI をパースした結果取得するためのクラス
class HTMLParser
	class << self
		# 文字コードをUTF-8にしてNokogiri::HTML::DOC を返す
		def get_doc(url)
			begin
				opened = open(url)
			rescue
				raise "URI:#{url} was not resolved"
			end

			read = NKF.nkf("--utf8", open(url).read)
			doc = Nokogiri.HTML(read, nil, 'utf8')
			return doc
		end

	end
end

