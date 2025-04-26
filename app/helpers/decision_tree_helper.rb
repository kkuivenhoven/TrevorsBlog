module DecisionTreeHelper

	def format_file_title(file)
		file_name = File.basename(file, ".*")
		formatted_name = file_name.tr("_", " ").titleize

		if formatted_name.downcase.include?("mcdonalds")
			formatted_name.gsub!(/McDonald/i, "McDonald'")
		end

		formatted_name
	end

end
