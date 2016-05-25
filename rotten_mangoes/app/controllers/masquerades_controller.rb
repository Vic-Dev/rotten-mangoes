class MasqueradesController < ApplicationController
  before_filter :authorize_admin

  def new
    session[:admin_id] = current_user.id
    user = User.find(params[:user_id])
    session[:user_id] = user.id
    redirect_to movies_path, notice: "Now masquerading as #{user.firstname}"
  end

  def destroy
    user = User.find(session[:admin_id])
    session[:user_id] = user.id
    session[:admin_id] = nil
    redirect_to admin_users_path, notice: "Stopped masquerading"
  end
end