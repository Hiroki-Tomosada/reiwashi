class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def login
    current_user = User.find_by(email: users_params[:email], password: users_params[:password])
    return render json: {status: 401, message: '認証に失敗しました'} unless current_user
    render plain: current_user.token

  rescue StandardError => e
    Rails.logger.error(e.message)
    render json: Init.message(500, e.message), status: 500
  end

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    #@user = User.new(user_params)
    @user = User.new(name: params[:name], email: params[:email], sex: params[:sex], age: params[:age], place: params[:place], password: params[:password], )

    if @user.save
      render json: @user, status: :created, location: @user
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
      params.require(:user).permit(:name, :email, :sex, :age, :place, :password)
    end
end
