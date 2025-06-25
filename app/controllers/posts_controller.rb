class PostsController < ApplicationController
  before_action :require_admin, only: [:new_upload, :upload]

  def index
    # List all available JSON files
	@files = Dir.glob(Rails.root.join('storage', 'blog_posts', '*.json')).map do |f|
	  # Read the file and parse the JSON
	  file_content = File.read(f)
	  json_data = JSON.parse(file_content)

	  # Extract the title and content
	  {
		title: json_data['title'],
		content: json_data['content'],
		date: Date.parse(json_data['date_published']),
		file_name: File.basename(f, '.json'), # Get the file name without the extension
		is_visible: json_data['is_visible']
	  }
	end

	# @files = @files.sort_by { |post| post[:date] }.reverse
	@files = @files.select { |file| file[:is_visible] == 1 }
				   .sort_by { |file| file[:date] }
				   .reverse

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
    file_path = Rails.root.join('storage', 'blog_posts', filename)
    
    if File.exist?(file_path)
      raw_content = File.read(file_path)
	  @raw_content = JSON.parse(raw_content)
	  if (@raw_content['is_visible'] == 1)
		  @post = JSON.parse(raw_content)
	  else
		redirect_to posts_index_path
	  end
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

  def new_upload
	# Renders the upload form
  end

  def upload
	uploaded_file = params[:json_file]

	unless uploaded_file && uploaded_file.content_type == 'application/json'
		flash[:alert] = 'Please upload a valid JSON file.'
		return redirect_to posts_new_upload_path
	end

	filename = uploaded_file.original_filename
	target_path = Rails.root.join('storage', 'blog_posts', filename)

	begin
		File.open(target_path, 'wb') do |file|
			file.write(uploaded_file.read)
		end
		flash[:notice] = "File uploaded successfully."
	rescue => e
		flash[:alert] = "Upload failed: #{e.message}"
	end
  end

  private

	def require_admin
        unless current_user && current_user.admin?
            redirect_to root_path, alert: "Admins only"
        end 
    end 

end
