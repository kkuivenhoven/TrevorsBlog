module DecisionTreeHelper

	def find_matching_file(target_file_path)
		@matchingJsonData = nil
		Dir.glob(Rails.root.join('storage', 'matching_data', '*.json')).each do |file_path|
			target_file_name = File.basename(target_file_path, ".*" + ".json")
			file_content = File.read(file_path)
			json_data = JSON.parse(file_content)
			if target_file_name == json_data['file_name']
				@matchingJsonData = json_data
			end
		end
		return @matchingJsonData
	end

end
