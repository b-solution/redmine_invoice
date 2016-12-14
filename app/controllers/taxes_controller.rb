class TaxesController < ApplicationController
  unloadable
  before_action :set_tax, only: [:edit, :update, :destroy, :show]
  before_action :authorize

  helper :issues
  include IssuesHelper


  def index
    @taxes = Tax.visible
  end

  def show
  end


  def new
    @tax = Tax.new
  end

  def create
    @tax = Tax.new
    @tax.safe_attributes = tax_params
    if @tax.save
      respond_to do |format|
        format.html { redirect_to tax_path(@tax), notice: 'Tax was successfully created.' }
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
    @tax.safe_attributes = tax_params
    if @tax.save
      respond_to do |format|
        format.html {
          flash[:notice] = 'Tax was successfully updated.'
          redirect_to tax_path(@tax)
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    @tax.active = false
    @tax.save
    respond_to do |format|
      format.html {
        flash[:notice] = 'Tax was successfully destroyed.'
        redirect_to taxes_path
      }
      format.json { head :no_content }
    end
  end


  private

  def set_tax
    @tax  = Tax.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def tax_params
    params.require(:tax).permit(:name, :type, :tax_applicables_attributes=> [:id, :tax_id, :rate, :applicable_from, :_destroy])
  end

  def authorize
    unless User.current.admin?
      render_403
    end
  end
end
