class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: %i[show edit update destroy]

  def index
    @records = current_user.records.order(played_on: :desc)
  end

  def show; end

  def new
    @record = Record.new
  end

  def edit; end

  def create
    @record = current_user.records.build(record_params)

    if @record.save
      redirect_to record_path(@record), notice: "ゴルフカルテを作成しました🆕"
    else
      flash.now[:alert] = "カルテの作成に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(record_params)
      redirect_to record_path(@record), notice: "ゴルフカルテを更新しました🆕"
    else
      flash.now[:alert] = "カルテの更新に失敗しました。入力内容を確認してください。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy
    redirect_to records_path, notice: "ゴルフカルテを削除しました🗑️", status: :see_other
  end

  private

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def record_params
    params.require(:record).permit(
      :golf_course_name,
      :played_on,
      :satisfaction,
      :companion,
      :score_18h,
      :score_9h,
      :tee,
      :weather,
      :pace,
      :play_style,
      :brand,
      :difficulty,
      :course_width,
      :fairway,
      :green_memo,
      :ob_risk,
      :bunker_difficulty,
      :hazard,
      :toilet_rating,
      :bath_memo,
      :shop_memo,
      :cart_type,
      :maintenance,
      :service,
      :food_rating,
      :food_memo,
      :total_cost,
      :cost_memo,
      :memo,
      green_features: [],
      driving_range: [],
      bath_features: [],
      plan_options: []
    )
  end
end
