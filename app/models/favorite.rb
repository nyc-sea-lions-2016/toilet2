class Favorite < ActiveRecord::Base
	belongs_to :favoriter, class_name: 'User'
	belongs_to :toilet

	validates :favoriter_id, :toilet, presence: true
	validate :unique_favorite

	def unique_favorite
		#check to make sure user has not already favorited a toilet.
	end


end
