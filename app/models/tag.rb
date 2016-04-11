class Tag < ActiveRecord::Base
		has_many :tagtoilets
		has_many :toilets, through: :tagtoilets
end
