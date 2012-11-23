class MessagesController < ApplicationController

  def index  
    page = params[:page] || 1
    per_page = 10
    @messages = Message.for_user(current_user).paginate(:page =>page,:per_page =>per_page)
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy    
    respond_to do |format|
      format.html { redirect_to(messages_path) }
      format.js {render :layout => false}      
    end
  end

  def read
    @message = current_user.messages.find(params[:id])
    if @message.read?
      @message.read = false
    else
      @message.read = true 
    end
    
    @message.save
    respond_to do |format|      
      format.js {render :layout => false}      
    end
  end

  def email
    @message = Message.find params[:id]    
    respond_to do |format|
      format.html { render :file=>"message_mailer/email",:layout => "emails" }
    end
  end


end
