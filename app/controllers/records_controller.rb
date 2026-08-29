class RecordsController < ApplicationController
  # ログインしていない人はアクセスできないようにする
  before_action :authenticate_user!

  def index
    # ログインしている自分のカルテだけを、プレー日の新しい順に取り出す
    @records = current_user.records.order(played_on: :desc)
  end

  def new
    # 白紙の新しいカルテを用意して画面に渡す
    @record = Record.new
  end

  def show
    # 他人のカルテを見られないよう current_user.records から取得（セキュリティ対策）
    @record = current_user.records.find(params[:id])
  end

  def edit
    # 直したいカルテを自分のデータの中から1冊取り出して画面に渡す
    @record = current_user.records.find(params[:id])
  end

  def create
    # ログイン中のユーザーに紐付いた新しいカルテを作成する
    @record = current_user.records.build(record_params)

    if @record.save
      redirect_to records_path, notice: "ゴルフカルテを作成しました！⛳️"
    else
      flash.now[:alert] = "カルテの作成に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @record = current_user.records.find(params[:id])

    if @record.update(record_params)
      redirect_to record_path(@record), notice: "ゴルフカルテを更新しました！⛳️"
    else
      flash.now[:alert] = "カルテの更新に失敗しました。入力内容を確認してください。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # 他人のカルテを削除できないよう自分のデータの中から探す（セキュリティ超重要）
    @record = current_user.records.find(params[:id])
    @record.destroy
    redirect_to records_path, notice: "ゴルフカルテを削除しました🗑️", status: :see_other
  end

  private

  # 🔐 ストロングパラメーター（不正データ防止のセキュリティ機能）
  def record_params
    params.require(:record).permit(
      :golf_course_name,
      :played_on,
      :satisfaction,
      :score_18h,
      :score_9h,
      :converted_score_18h,
      :difficulty,
      :food,
      :facility,
      :memo
    )
  end
end
