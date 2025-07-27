class NotificationMailer < ApplicationMailer
  helper :application
  default from: "noreply@mail.trevorbalthrop.com"

  def fraud_simulator_notification(user, id)
	@user = user
	@simulator = FraudSimulator.find(id)
	mail(to: @user.email, subject: "New Fraud Simulator Available!")
  end

  def blog_post_notification(user, id)
	@user = user
	@blog_post = BlogPost.find(id)
	mail(to: @user.email, subject: "Trevor's New Blog Post!")
  end

end
