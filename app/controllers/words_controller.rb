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
    unless @age.blank? then
      @age = params[:age].to_i
      @birthday_start = Time.now - @age.year - 10.year
      @birthday_end = Time.now - @age.year
    else
      @age = params[:age]
    end

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


    #render plain: @start_date.to_s + @end_date.to_s

    #@all_ranks = Word.find(Fab.group(:word_id).order('count(word_id) desc').limit(30).pluck(:word_id))

    @words = Word.where(:created_at => @start_date..@end_date)

    unless @sex.blank? then
      unless @age.blank? then
        @word_fab_count = Word.where(words: {:created_at => @start_date..@end_date}).joins(:fabs).where(fabs: {sex: @sex}).where(fabs: {:birthday => @birthday_start..@birthday_end}).group(:word_id).count
        #render plain: "sex, age"
      else
        @word_fab_count = Word.where(words: {:created_at => @start_date..@end_date}).joins(:fabs).where(fabs: {sex: @sex}).group(:word_id).count
        #render plain: "sex"
      end
    else
      unless @age.blank? then
        @word_fab_count = Word.where(words: {:created_at => @start_date..@end_date}).joins(:fabs).where(fabs: {:birthday => @birthday_start..@birthday_end}).group(:word_id).count
        #render plain: "age"
      else
        @word_fab_count = Word.where(words: {:created_at => @start_date..@end_date}).joins(:fabs).group(:word_id).count
        #render plain: "no"
      end
    end

    
    #render json: @words

    #@word_fab_count = Word.where(words: {:created_at => @start_date..@end_date}).where(words: {:birthday => @birthday_start..@birthday_end}).where(words: {sex: @sex}).joins(:fabs).group(:word_id).count
        
    word_fabs_ids = Hash[@word_fab_count.sort_by{ |_, v| -v }].keys

    if word_fabs_ids.blank? then
      render json: {status: 'nothing'}
    else
      @word_ranking= Word.where(id: word_fabs_ids).order("field(id, #{word_fabs_ids.join(',')})")

      #@response = []
      #@word_ranking.each_with_index do |word, i|
      #  @response << word
      #end

      #render json: @response, except:[:id, :user_id, :tag_id, :sex, :birthday, :place, :updated_at]
      render json: {word: @word_ranking, fabs: @word_fab_count}
    end
    
    #respond_to do |format|
    #  format.html # => 通常のURLの場合、index.html.erb が返される
    #  format.json { render json: @word_ranking } # URLが.jsonの場合、@products.to_json が返される
    #end
   
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
