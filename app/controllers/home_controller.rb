class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def welcome
  end

  def index
    redirect_to :welcome
  end
end
