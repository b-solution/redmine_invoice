class ClientsController < ApplicationController
  unloadable
  before_action :set_client, only: [:edit, :update, :destroy, :show]
  before_action :authorize

  helper :issues
  include IssuesHelper

  def index
    @clients = Client.visible
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new
    @client.safe_attributes = client_params
    if @client.save
      respond_to do |format|
        format.html { redirect_to client_url(@client), notice: 'Client was successfully created.' }
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
    @client.safe_attributes = client_params
    if @client.save
      respond_to do |format|
        format.html { redirect_to client_url(@client), notice: 'Client was successfully updated.' }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    @client.active = false
    @client.save
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_client
    @client  = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def client_params
    params.require(:client).permit!
  end

  def authorize
    unless User.current.admin?
      render_403
    end
  end
end
