class PaymentMethodsController < ApplicationController

  def index
    @payment_methods = PaymentMethod.all
  end

  def new
    @payment_method = PaymentMethod.new
  end

   def edit
    @payment_method = PaymentMethod.find(params[:id])
  end

  def create
    @payment_method = PaymentMethod.new(params[:payment_method])
    if @payment_method.save
      flash[:notice] = 'La Tarea ha sido creada.'
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
end
