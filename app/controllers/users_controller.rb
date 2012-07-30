class UsersController < ApplicationController

  before_filter :authenticate_user!
  respond_to :json

  def index
    @users = User.all
    respond_with(@users)
  end
end
