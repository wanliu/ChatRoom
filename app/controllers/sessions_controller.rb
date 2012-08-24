class SessionsController < ApplicationController
  def create
    #binding.pry
    auth = request.env["omniauth.auth"]
    #binding.pry
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    #binding.pry
    session[:user_id] = user.id
    session[:current_user] = user
    redirect_to root_url, :notice => "Signed in!"
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
