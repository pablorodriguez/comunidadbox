class AdminController < ApplicationController
  layout 'application'
  authorize_resource :class => false

  def show
  end
end
