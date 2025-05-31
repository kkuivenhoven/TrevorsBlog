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
		date: Date.parse(json_data['date_published']),
		file_name: File.basename(f, '.json') # Get the file name without the extension
	  }
	end

	@files = @files.sort_by { |post| post[:date] }.reverse

	# If a search term is provided, filter the posts
	if params[:search].present?
		search_term = params[:search].downcase
		@files = @files.select do |post|
			post[:title].downcase.include?(search_term) || post[:content].downcase.include?(search_term)
		end
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

  def send_notification_email
	file_name = params[:file_name]
	User.where(notify_blog_posts: true).find_each do |user|
		NotificationMailer.blog_post_notification(user, file_name).deliver_now
	end

	head :ok
  end

end
