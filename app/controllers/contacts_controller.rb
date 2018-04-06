class ContactsController < ApplicationController
  before_action :set_user
  before_action :set_user_contact, only: [:show, :update, :destroy]

  # GET /users/:user_id/contacts
  def index
    contact_search_data = contact_search_params
    per_page = 10
    if contact_search_data[:page].present? && contact_search_data[:page].to_i > 0
      page = contact_search_data[:page].to_i
    else
      page = 1
    end
    offset = (page - 1) * per_page
    if contact_search_data[:q].present?
      query = '%' + contact_search_data[:q] + '%'
      total_count = @user.contacts.where('contacts.email LIKE ? OR contacts.firstname LIKE ? OR contacts.lastname LIKE ?', query, query, query).count
      contacts = @user.contacts.where('contacts.email LIKE ? OR contacts.firstname LIKE ? OR contacts.lastname LIKE ?', query, query, query).limit(per_page).offset(offset)
    else
      total_count = @user.contacts.count
      contacts = @user.contacts.limit(per_page).offset(offset)
    end
    total_pages = (total_count.to_f / per_page.to_f).ceil
    json_response({ contacts: contacts, total_pages: total_pages, page: page })
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

  def contact_search_params
    params.permit(:q, :page, :user_id)
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
