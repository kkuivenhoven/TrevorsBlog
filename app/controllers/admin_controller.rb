class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  
  def dashboard
	# any data you want to show
    # List all available JSON files
	@posts = Dir.glob(Rails.root.join('storage', 'blog_posts', '*.json')).map do |f|
	  # Read the file and parse the JSON
	  file_content = File.read(f)
	  json_data = JSON.parse(file_content)

	  # Extract the title and content
	  {
		title: json_data['title'],
		content: json_data['content'],
		date: Date.parse(json_data['date_published']),
		file_name: File.basename(f, '.json') # Get the file name without the extension
	  }
	end

	@posts = @posts.sort_by { |post| post[:date] }.reverse
	@decision_trees = Dir.glob(Rails.root.join('app/assets/data/*.json'))
  end

  private

	def require_admin
		redirect_to root_path, alert: "Not authorized" unless current_user.admin?
	end

end
