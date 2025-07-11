class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: [:show, :edit, :update, :destroy]

  def index
    @blog_posts = BlogPost.all.order(date_published: :desc)

	# If a search term is provided, filter the posts
	if params[:search].present?
		search_term = params[:search].downcase
		@blog_posts = @blog_posts.select do |post|
			post[:title].downcase.include?(search_term) || post[:content].downcase.include?(search_term)
		end
	end
  end

  def show
  end

  def new
    @blog_post = BlogPost.new
    @blog_post.blog_post_images.build
    @blog_post.blog_post_sources.build
  end

  def edit
	  @blog_post = BlogPost.find(params[:id])
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)
    if @blog_post.save
      redirect_to @blog_post, notice: 'Blog post was successfully created.'
    else
      render :new
    end
  end

  def update
    @blog_post = BlogPost.find(params[:id])
    if @blog_post.update(blog_post_params)
      redirect_to @blog_post, notice: 'Blog post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to blog_posts_url, notice: 'Blog post was successfully deleted.'
  end

  private

  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
  end

  def blog_post_params
    params.require(:blog_post).permit(
      :title,
      :excerpt,
      :content,
      :date_published,
      :is_visible,
      :file_name,
      blog_post_images_attributes: [:id, :image_url, :_destroy],
      blog_post_sources_attributes: [:id, :source_url, :_destroy]
    )
  end
end
