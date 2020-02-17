class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  #skip_before_action :authenticate!, only: [:create, :sign_in]

  def sign_in
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      render json: @user.token
    else
      render json: { errors: ['ログインに失敗しました'] }, status: 401
    end
  end

  #def login
  #  current_user = User.find_by(email: users_params[:email], password: users_params[:password])
  #  return render json: {status: 401, message: '認証に失敗しました'} unless current_user
  #  render plain: current_user.token

  #rescue StandardError => e
  #  Rails.logger.error(e.message)
  #  render json: Init.message(500, e.message), status: 500
  #end

  # GET /users
  def index
    @users = User.all

    render json: {status: "success", users: @users}
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    #@user = User.new(user_params)
    @user = User.new(name: params[:name], email: params[:email], sex: params[:sex], birthday: params[:birthday], place: params[:place], password: params[:password])

    if @user.save
      render json: @user.token, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
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
end
