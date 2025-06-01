module ApplicationHelper

	def ordinal_suffix(day)
	  suffix = day.ordinalize[-2..-1] # Get the suffix (st, nd, rd, th)
	  "<span class='ordinal'>#{suffix}</span>" # Wrap the suffix in a span with a class
	end

	def format_file_title(file)
		file_name = File.basename(file, ".*")
		formatted_name = file_name.tr("_", " ").titleize

		if formatted_name.downcase.include?("mcdonalds")
			formatted_name.gsub!(/McDonald/i, "McDonald'")
		end

		formatted_name
	end

end
