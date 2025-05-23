class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  
  def dashboard
	# any data you want to show
  end

  private

	def require_admin
		redirect_to root_path, alert: "Not authorized" unless current_user.admin?
	end

end
