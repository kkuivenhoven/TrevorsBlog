module ApplicationHelper

	def ordinal_suffix(day)
	  suffix = day.ordinalize[-2..-1] # Get the suffix (st, nd, rd, th)
	  "<span class='ordinal'>#{suffix}</span>" # Wrap the suffix in a span with a class
	end

end
