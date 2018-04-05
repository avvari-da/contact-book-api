class ContactsController < ApplicationController
  before_action :set_user
  before_action :set_user_contact, only: [:show, :update, :destroy]

  # GET /users/:user_id/contacts
  def index
    json_response({ contacts: @user.contacts })
  end

  # GET /users/:user_id/contacts/:id
  def show
    json_response(@contact)
  end

  # POST /users/:user_id/contacts
  def create
    contact_data = contact_params
    if @user.contacts.where(email: contact_data[:email]).count == 0
      @contact = @user.contacts.create(contact_data)
      json_response(@contact, :created)
    else
      json_response({message: 'Contact already exists'}, :conflict)
    end
  end

  # PUT /users/:user_id/contacts/:id
  def update
    contact_data = contact_params
    if @user.contacts.where(email: contact_data[:email]).where("contacts.id != ?", contact_data[:id]).count == 0
      @contact.update(contact_data)
      head :no_content
    else
      json_response({message: 'Contact already exists'}, :conflict)
    end
  end

  # DELETE /users/:user_id/contacts/:id
  def destroy
    @contact.destroy
    head :no_content
  end

  private

  def contact_params
    params.permit(:id, :firstname, :lastname, :email, :user_id)
  end

  def set_user
    @user = User.find(params[:user_id])
    if !request.headers["Authorization"].present? || request.headers["Authorization"] != "Token " + @user.get_user_latest_active_access_token
      json_response({message: 'Unauthorized'}, :unauthorized)
    end
  end

  def set_user_contact
    @contact = @user.contacts.find_by!(id: params[:id]) if @user
  end
end
