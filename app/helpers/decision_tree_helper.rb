module DecisionTreeHelper

	def format_file_title(file)
		file_name = File.basename(file, ".*")
		file_name.tr("_", " ").titleize
	end

end
