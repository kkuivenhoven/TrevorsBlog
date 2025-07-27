class NotificationMailer < ApplicationMailer
  helper :application
  default from: "noreply@mail.trevorbalthrop.com"

  def fraud_simulator_notification(user, simulator)
	@user = user
	@simulator = simulator
	mail(to: @user.email, subject: "New Fraud Simulator Available!")
  end

  def blog_post_notification(user, id)
	@user = user
	@blog_post = BlogPost.find(id)
	mail(to: @user.email, subject: "Trevor's New Blog Post!")
=begin
	filename = file_name + '.json'
	file_path = Rails.root.join('app/assets/blog_posts', filename)

	if File.exist?(file_path)
		raw_content = File.read(file_path)
		@blog_post = JSON.parse(raw_content)
		mail(to: @user.email, subject: "Trevor's New Blog Post!")
	end
=end
  end

end
