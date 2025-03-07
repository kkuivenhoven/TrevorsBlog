class PostsController < ApplicationController

  def index
    # List all available JSON files
	@files = Dir.glob(Rails.root.join('app/assets/blog_posts/*.json')).map do |f|
	  # Read the file and parse the JSON
	  file_content = File.read(f)
	  json_data = JSON.parse(file_content)

	  # Extract the title and content
	  {
		title: json_data['title'],
		content: json_data['content'],
		file_name: File.basename(f, '.json') # Get the file name without the extension
	  }
	end
  end

  def show
    # Read and parse the content of a specific JSON file
    filename = params[:file_name] + '.json'
    file_path = Rails.root.join('app/assets/blog_posts', filename)
    
    if File.exist?(file_path)
      raw_content = File.read(file_path)
      @post = JSON.parse(raw_content)
    else
      render file: 'public/404.html', status: :not_found
    end
  end

end
