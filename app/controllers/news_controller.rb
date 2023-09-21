class NewsController < ApplicationController

	# fetch all news
	def index
		begin
			news = NewsService.fetch
			render json: { news: news }, status: :ok
		rescue
			render json: { news: [], message: "Something went wrong!" }, status: :internal_server_error
		end
	end
end
