class FonixDashboardController < ApplicationController
	def show
    	@current_user = current_user
    	@fonix_auth = FonixAuth.new
  	end
end
