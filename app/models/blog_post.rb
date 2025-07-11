class BlogPost < ApplicationRecord
	has_many :blog_post_images, dependent: :destroy
	has_many :blog_post_sources, dependent: :destroy

	accepts_nested_attributes_for :blog_post_images, allow_destroy: true
	accepts_nested_attributes_for :blog_post_sources, allow_destroy: true
end
