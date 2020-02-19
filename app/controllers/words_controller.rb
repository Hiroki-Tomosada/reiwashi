class WordsController < ApplicationController
  before_action :set_word, only: [:show, :update, :destroy]

  before_action :authenticate, except: [:index, :api]
  before_action :current_user, except: [:index, :api]

  # GET /words/api
  def api
    require 'date'
    
    #render :text => "id = #{params[:id]}"
    #render plain: "period = #{params[:period]}, category = #{params[:category]}, private = #{params[:private]}"
    
    @period = params[:period]
    @page = params[:page].to_i
    @age = params[:age].to_i
    @sex = params[:sex]

    @now_date = Date.today

    if @period == 'year' then
      @start_date = Time.now - @page.year
      @end_date = Time.now - (@page - 1).year

    elsif @period == 'month' then
      @start_date = Time.now - @page.month
      @end_date = Time.now - (@page - 1).month

    elsif @period == 'week' then
      @start_date = Time.now - @page.week
      @end_date = Time.now - (@page - 1).week

    else
      render json: {status: "error"}
    end

    @birthday_start = Time.now - @age.year - 10.year
    @birthday_end = Time.now - @age.year

    #render plain: @start_date.to_s + @end_date.to_s

    @words = Word.where('created_at >= ? and created_at <= ?', @start_date, @end_date)

    unless @sex.blank? then
      @words = @words.where(sex: @sex)

      unless @age.blank? then
        @words = @words.where('birthday >= ? and birthday <= ?', @birthday_start, @birthday_end)
      end
    else
      unless @age.blank? then
        @words = @words.where('birthday >= ? and birthday <= ?', @birthday_start, @birthday_end)
      end
    end

    @all_ranks = @words.find(Fab.group(:word_id).order('count(word_id) desc').limit(1).pluck(:word_id))

    render json: @all_ranks
    
   
  end

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
    @word = Word.new(name: word_params[:name], user_id: @current_user.id, sex: @current_user.sex, birthday: @current_user.birthday, place: @current_user.place)

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
