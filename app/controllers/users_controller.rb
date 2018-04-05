class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_user_for_login, only: [:login]

  # GET /users
  def index
    @users = User.all
    json_response(@users)
  end

  # POST /users
  def create
    user_data = user_params
    if User.where(email: user_data[:email]).count == 0
      user_data[:password] = Digest::MD5.hexdigest(user_data[:password]) unless user_data[:password].nil?
      @user = User.create(user_data)
      json_response(
        {
          id: @user.id,
          name: @user.name,
          email: @user.email,
          token: UserToken.create!(user: @user).access_token
        },
        :created
      )
    else
      json_response({message: 'User already exists'}, :conflict)
    end
  end

  # GET /users/:id
  def show
    json_response(
      {
        id: @user.id,
        name: @user.name,
        email: @user.email,
        last_login: UserToken.where(user: @user, active: true).try(:last).created_at
      }
    )
  end

  # LOGIN /users/login
  def login
    if @user.nil?
      json_response(
        {
          message: 'Email ID does not exist'
        },
        :bad_request
      )
    elsif !user_login_params[:password].present? || @user.password != Digest::MD5.hexdigest(user_login_params[:password])
      json_response(
        {
          message: 'Password incorrect'
        },
        :bad_request
      )
    else
      # Remove all previous tokens
      UserToken.where(user_id: @user.id).update(active: false)

      #Create new token & send
      json_response(
        {
          id: @user.id,
          name: @user.name,
          email: @user.email,
          token: UserToken.create!(user: @user).access_token
        },
        :created
      )
    end
  end

  private

  def user_params
    # whitelist params
    params.permit(:name, :email, :password)
  end

  def user_login_params
    # whitelist params
    params.permit(:email, :password)
  end

  def set_user
    @user = User.find(params[:id])
    if !request.headers["Authorization"].present? || request.headers["Authorization"] != "Token " + @user.get_user_latest_active_access_token
      json_response({message: 'Unauthorized'}, :unauthorized)
    end
  end

  def set_user_for_login
    @user = User.find_by_email(user_login_params[:email])
  end
end
