class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :authenticate, except: [:index, :sign_in, :create]
  before_action :current_user, except: [:index, :sign_in, :create]

  def sign_in
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      render json: {status: "success", token: @user.token, user_id: @user.id}
    else
      render json: {status: "error"}
    end
  end

  # GET /users
  def index
    @users = User.all

    render json: {status: "success", users: @users}
  end

  # GET /users/1
  def show
    render json: @current_user
  end

  # POST /users
  def create
    #@user = User.new(user_params)
    @user = User.new(name: params[:name], email: params[:email], sex: params[:sex], birthday: params[:birthday], place: params[:place], password: params[:password])

    if User.find_by(email: params[:email]).present?
      render json: {status: "already"}
    else
      if @user.save
        #render json: @user.token, status: :created, location: @user
        render json: {status: "success", token: @user.token, user_id: @user.id}
      else
        #render json: @user.errors, status: :unprocessable_entity
        render json: {status: "error"}
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    if @current_user.update(user_params)
      #render json: @user
      render json: {status: "success"}
    else
      #render json: @user.errors, status: :unprocessable_entity
      render json: {status: "error"}
    end
  end

  # DELETE /users/1
  def destroy
    @current_user.destroy
    
    fabs = Fab.where(user_id: @current_user.id)
    fabs.destroy_all

    words = Word.where(user_id: @current_user.id)
    words.destroy_all
    
    render json: {status: "success"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :sex, :birthday, :place, :password)
    end
    
    # 認証処理
    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        # Compare the tokens in a time-constant manner, to mitigate
        # timing attacks.
        #ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
        User.find_by(token: token).present?
      end
    end

    def current_user
      @current_user ||= User.find_by(token: request.headers['Authorization'].split[1])
    end
end
