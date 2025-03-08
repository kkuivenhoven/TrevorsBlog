module ApplicationHelper

	def ordinal_suffix(day)
		suffix = case day % 10
				 when 1 then 'ST'
				 when 2 then 'ND'
				 when 3 then 'RD'
				 else 'TH'
				end
		"<span class='ordinal-suffix'>#{suffix}</span>".html_safe
	end

end
