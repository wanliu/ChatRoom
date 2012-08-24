#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

class UsersController < ApplicationController

  before_filter :authenticate_user!
  respond_to :json, :html

  def index
    @users = User.all
    respond_with(@users)
  end

  def show
  	@user = User.find(params[:id])
  	respond_with @user
  end

  def get_current_user
    respond_with current_user
  end
end
