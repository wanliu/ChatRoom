#Encoding:utf-8
class SessionsController < ApplicationController
  def create
    #binding.pry
    auth = request.env["omniauth.auth"]
    #binding.pry
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    #binding.pry
    debugger
    session["warden.user.user.key"] = Warden::SessionSerializer.new(User).serialize(user)
    redirect_to root_url, :notice => "登录成功！"
  end
  
  def destroy
    session.delete "warden.user.user.key"
    redirect_to root_url, :notice => "注销成功！"
  end
end
