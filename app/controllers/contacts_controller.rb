class ContactsController < ApplicationController
  skip_before_filter :authenticate_user!
  authorize_resource :class => false

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if verify_recaptcha      
      @contact.save    
      Resque.enqueue ContactJob,@contact.id
      flash[:notice] = t("message_exit_send")
      redirect_to root_path
    else
      flash[:alert] = t("wrong_captcha")
      render :action => "new"
    end
  end
end
