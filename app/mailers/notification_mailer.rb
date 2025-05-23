class NotificationMailer < ApplicationMailer
  default from: "noreplay@mail.trevorbalthrop.com"

  def fraud_simulator_notification(user, simulator)
	@user = user
	@simulator = simulator
	mail(to: @user.email, subject: "New Fraud Simulator Available!")
  end

  def blog_post_notification(user, post)
	@user = user
	@blog_post = post
	mail(to: @user.email, subject: "New Blog Post Published!")
  end

end
