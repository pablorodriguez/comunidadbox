class PaymentMethodsController < ApplicationController

  layout "application"
  
  def index
    get_payment_methods
  end

  def new
    @payment_method = PaymentMethod.new
  end

   def edit
    @payment_method = PaymentMethod.find(params[:id])
  end

  def create
    @payment_method = PaymentMethod.new(params[:payment_method])
    @payment_method.company = get_company
    if @payment_method.save
      flash[:notice] = 'Forma de Pago creada.'
      redirect_to(@payment_method)
    else
      render :action => "new"
    end
  end

  def show
    @payment_method = PaymentMethod.find(params[:id])
  end

  def update
    @payment_method = PaymentMethod.find(params[:id])
    if @payment_method.update_attributes(params[:payment_method])
      flash[:notice] = 'Forma de Pago actualizada.'
      redirect_to(@payment_method)
    else
      render :action => "edit"
    end
  end

  def destroy
    payment_method = PaymentMethod.find(params[:id])
    if payment_method
      payment_method.destroy
    end
    redirect_to(payment_methods_url)
  end

  private
    def get_payment_methods
      company = get_company
      @payment_methods = company.payment_methods
    end
end
