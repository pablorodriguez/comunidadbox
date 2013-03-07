class MessagesController < ApplicationController

  def index  
    page = params[:page] || 1
    per_page = 50
    @user = User.find(params[:user_id])
    @messages = Message.between(@user,current_user).paginate(:page =>page,:per_page =>per_page)
  end

  def users
    page = params[:page] || 1
    per_page = 10
    @clients = Message.for_user(current_user).paginate(:page =>page,:per_page =>per_page)
  end

  def new
    @msg = Message.new
  end

  def create   
    @message = Message.new(params[:message])
    @message.receiver_id = params[:user_id]
    @message.user = current_user
    @element_id = params[:element_id]
    
    respond_to do |format|               
      if @message.save      
        format.js {render :file=>"messages/create",:layout => false}   
      else
        format.js {render :file=>"messages/error",:layout => false}   
      end
    end
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
    @message = Message.find(params[:id])
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
