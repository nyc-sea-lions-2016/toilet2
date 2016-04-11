class FavoritesController < ApplicationController

	def new
		@favorite = Favorite.new(
			toilet_id: params[:id],
			favoriter_id: session[:user_id]
			)
		if @favorite.save
			redirect_to action: 'show', controller: 'toilets', id: params[:id]
		else
			redirect_to action: 'show', controller: 'toilets', id: params[:id]
		end
	end

end
