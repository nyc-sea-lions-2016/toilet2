class Tagtoilet < ActiveRecord::Base
	belongs_to :tag
	belongs_to :toilet

end
