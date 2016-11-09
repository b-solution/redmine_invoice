class PaymentsController < ApplicationController
  unloadable
  before_action :set_payment, only: [:edit, :update, :destroy, :show]
  before_action :authorize_global

  helper :issues
  include IssuesHelper


  def index
    if params[:invoice_id]
      @payments = PaymentReceipt.where(invoice_id: params[:invoice_id] )
    elsif params[:issue_id]
      @payments = PaymentReceipt.where(issue_id: params[:issue_id] )
    else
      @payments = PaymentReceipt.all
    end
  end

  def show

  end


  def new
    @payment = PaymentReceipt.new(invoice_id: params[:invoice_id])
    i = Invoice.find(params[:invoice_id])
    @payment.issue_id = i.issue_id
    @payment.project_id = i.project_id
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def create
    @payment = PaymentReceipt.new
    @payment.safe_attributes = payment_params
    if @payment.save
      respond_to do |format|
        format.html { redirect_to payment_path(@payment), notice: 'Payment was successfully created.' }
      end

    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit

  end

  def update
    @payment.safe_attributes = payment_params
    if @payment.save
      respond_to do |format|
        format.html { redirect_to payment_path(@payment), notice: 'Payment was successfully updated.' }
      end

    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = 'Payment was successfully destroyed.'
        redirect_to payments_path
      }
      format.json { head :no_content }
    end
  end


  private

  def set_payment
    @payment  = PaymentReceipt.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def payment_params
    params.require(:payment).permit!
  end
end
