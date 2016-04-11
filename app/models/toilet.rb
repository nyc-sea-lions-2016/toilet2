class Toilet < ActiveRecord::Base
	has_many :reviews
	has_many :favorites
	has_many :reviewers, through: :reviews, class_name: 'User', foreign_key: 'reviewer_id'
	has_many :favoriters, through: :favorites
	has_many :tagtoilets
	has_many :tags, through: :tagtoilets
	validates :name, :location, presence: true

  geocoded_by :full_street_address # can also be an IP address

  def full_street_address
    location + "New York City, NY, USA"
  end

	def self.average_review(toilet)
		if (toilet.reviews.length) > 0
			(toilet.reviews.reduce(0){|sum,review| sum += review.rating})/(toilet.reviews.length)
		else
			'Be the first to review this toilet!'
		end
	end

	def distance_to(search_latitude, search_longitude)

		toilet_location = [latitude.to_f, longitude.to_f]
		other_location = [search_latitude, search_longitude]

  	rad_per_deg = Math::PI/180
  	rkm = 6371 # Earth radius in kilometers
  	rm = rkm * 1000 # Radius in meters

  	dlat_rad = (other_location[0]-toilet_location[0]) * rad_per_deg  # Delta, converted to rad
  	dlon_rad = (other_location[1]-toilet_location[1]) * rad_per_deg

  	lat1_rad, lon1_rad = toilet_location.map {|i| i * rad_per_deg }
  	lat2_rad, lon2_rad = other_location.map {|i| i * rad_per_deg }

  	a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  	c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  	rm * c # Resulting distance is in meters
	end



end
