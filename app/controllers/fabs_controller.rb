class FabsController < ApplicationController
  before_action :set_fab, only: [:show, :update, :destroy]

  # GET /fabs/api
  def api
    #render :text => "id = #{params[:id]}"
    #render plain: "period = #{params[:period]}, category = #{params[:category]}, private = #{params[:private]}"

    period = params[:period]
    category = params[:category]
    privates = params[:private]

    unless privates.blank? then
      #@fabs = Fab.where
      render plain: "[Private mode] period = #{period}, category = #{category}, private = #{privates}"
    else
      if category.blank? then
        #@fabs = Fab.where(["name = ? and tel = ?", "hoge太郎", "090-1111-2222"])
        render plain: "[Full category mode] period = #{period}, category = #{category}, private = #{privates}"
      else
        #@fabs = Fab.where(["name = ? and tel = ?", "hoge太郎", "090-1111-2222"])
        render plain: "[Category mode] period = #{period}, category = #{category}, private = #{privates}"
      end
    end
    
  end

  # GET /fabs
  def index
    @fabs = Fab.all

    render json: @fabs
  end

  # GET /fabs/1
  def show
    render json: @fab
  end

  # POST /fabs
  def create
    @fab = Fab.new(fab_params)

    if @fab.save
      render json: @fab, status: :created, location: @fab
    else
      render json: @fab.errors, status: :unprocessable_entity
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
    @fab.destroy
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
end
