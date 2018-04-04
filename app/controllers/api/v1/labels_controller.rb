class Api::V1::LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  # GET /labels
  # GET /labels.json
  def index
    @labels = Label.all
  end

  # GET /labels/1
  # GET /labels/1.json
  def show
     if !@label
      return render json: {status: -1, notice: '数据不存在'}
    end
  end

  # GET /labels/new
  def new
    @label = Label.new
  end

  # GET /labels/1/edit
  def edit
     @label = Label.find(params[:id])
  end

  # POST /labels
  # POST /labels.json
  def create
    @label = Label.new(label_params)
    if @label.save
      render :show, status: :created, location: @label 
    else 
      render json: @label.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /labels/1
  # PATCH/PUT /labels/1.json
  def update
    status = @label.update(label_params) rescue false #异常抛出
      result = {status: 1, notice: '更改成功！'}
    unless status
      result = {status: -1, notice: '数据不存在！'}
    end
      render json: result
  end

  # DELETE /labels/1
  # DELETE /labels/1.json
  def destroy
    status = @label.destroy rescue false
      result = {status: 1, notice: '删除成功！' }
      
      unless status
        result = { status: -1, notice: "数据不存在！"}
      end
        render json: result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_label
      @label = Label.find(params[:id]) rescue nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def label_params
      params.require(:label).permit(:name)
    end
end
