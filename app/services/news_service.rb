require 'open-uri'

class NewsService
	def initialize
		@base_url = "https://news.google.com/"
	end

	def get_sports_news
		# fetch news page and from there fetch sports page to get sports news
		sports_panel = get_sports_news_page.at_css('div[role="tabpanel"] c-wiz')
		sports_panel.search('c-wiz').map do |element|
			# create article link
			article_url = URI.join(@base_url, element.at_css('a')['href'])
			{ title: element.at_css('h4').text, link:  article_url }
		end.uniq
	end

	def get_sports_news_page
		# get details of sports page
		sports_anchor = get_news_page.at_css('header c-wiz[role="navigation"] a[aria-label="Sports"]')
		sports_page_link = URI.join(@base_url, sports_anchor['href']).to_s
		Nokogiri::HTML(URI.open(sports_page_link))
	end

	def get_news_page
		# get news dashboard page
		news_page = URI.open(@base_url)
		Nokogiri::HTML(news_page)
	end

	class << self
		# this can be further improved
		# we can have section to be fetched in arguments and divided/created and rendered news from their own service class
		# for now returning only sports news, assuming there is no section parameter
		def fetch
			NewsService.new.get_sports_news
		end
	end
end