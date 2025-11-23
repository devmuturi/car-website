module Admin
  class BaseController < ApplicationController
    layout "admin/layouts/application"
    before_action :authenticate_user!
    before_action :ensure_admin
    
    private
    
    def ensure_admin
      unless current_user&.admin?
        redirect_to root_path, alert: "You don't have permission to access this page."
      end
    end
  end
end

