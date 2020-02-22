class FabsController < ApplicationController
  #before_action :set_fab, only: [:show, :update, :destroy]
  before_action :set_fab, only: [:update, :destroy]

  before_action :authenticate, except: [:index, :api]
  before_action :current_user, except: [:index, :api]

  # GET /fabs
  def index
    @fabs = Fab.all

    render json: @fabs
  end

  # GET /fabs/1
  def show
    #render json: @fab
    fab = Fab.find_by(word_id: params[:id], user_id: @current_user.id)
    render json: fab
  end

  def mypage
    fabs = Fab.where(user_id: @current_user)
    render json: fabs
  end

  # POST /fabs
  def create
    #@fab = Fab.new(fab_params)
    @fab = Fab.new(word_id: fab_params[:word_id], user_id: @current_user.id)

    if Fab.find_by(word_id: @fab.word_id, user_id: @fab.user_id).present?
      render json: {status: "already"}
    else
      if @fab.save
        #render json: @fab, status: :created, location: @fab
        render json: {status: "success"}
      else
        #render json: @fab.errors, status: :unprocessable_entity
        render json: {status: "error"}
      end
    end
  end

  # PATCH/PUT /fabs/1
  def update
    if @fab.update(fab_params)
      render json: @fab
    else
      render json: @fab.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fabs/1
  def destroy
    #@fab.destroy
    fab = Fab.find_by(word_id: params[:id], user_id: @current_user.id)
    if fab.present?
      fab.destroy
      render json: {status: "success"}
    else
      render json: {status: "nothing"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fab
      @fab = Fab.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fab_params
      #params.fetch(:fab, {})
      params.require(:fab).permit(:word_id, :user_id)
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
