class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
  	session["hello"] = "world"
  end
end
