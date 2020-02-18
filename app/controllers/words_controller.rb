class WordsController < ApplicationController
  before_action :set_word, only: [:show, :update, :destroy]

  before_action :authenticate, except: [:index]
  before_action :current_user, except: [:index]

  # GET /words
  def index
    @words = Word.all

    render json: @words
  end

  # GET /words/1
  def show
    render json: @word
  end

  # POST /words
  def create
    # @word = Word.new(word_params)
    @word = Word.new(name: word_params[:name], user_id: @current_user.id)

    if Word.find_by(name: @word.name).present?
      render json: {status: "already"}
    else
      if @word.save
        #render json: @word, status: :created, location: @word
        render json: {status: "success"}
      else
        #render json: @word.errors, status: :unprocessable_entity
        render json: {status: "error"}
      end
    end
  end

  # PATCH/PUT /words/1
  def update
    if @word.update(word_params)
      render json: @word
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  # DELETE /words/1
  def destroy
    @word.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def word_params
      #params.fetch(:word, {})
      params.require(:word).permit(:name, :user_id, :tag_id)
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
