module ToiletsHelper

	def tags(toilet)
		tags_arr = toilet.tags.map{|tag| tag.tag}
		tags_arr.join(', ')
	end


end
