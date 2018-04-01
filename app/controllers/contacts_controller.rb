class ContactsController < ApplicationController
  before_action :set_user
  before_action :set_user_contact, only: [:show, :update, :destroy]

  # GET /users/:user_id/contacts
  def index
    json_response(@user.contacts)
  end

  # GET /users/:user_id/contacts/:id
  def show
    json_response(@contact)
  end

  # POST /users/:user_id/contacts
  def create
    @contact = @user.contacts.create!(contact_params)
    json_response(@contact, :created)
  end

  # PUT /users/:user_id/contacts/:id
  def update
    @contact.update(contact_params)
    head :no_content
  end

  # DELETE /users/:user_id/contacts/:id
  def destroy
    @contact.destroy
    head :no_content
  end

  private

  def contact_params
    params.permit(:firstname, :lastname, :email)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_contact
    @contact = @user.contacts.find_by!(id: params[:id]) if @user
  end
end
