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

  def create
    # ログイン中のユーザーに紐付いた新しいカルテを作成する
    @record = current_user.records.build(record_params)

    if @record.save
      # 保存に成功した場合：カルテ一覧画面へ移動（メッセージ付き）
      redirect_to records_path, notice: "ゴルフカルテを作成しました！⛳️"
    else
      # 保存に失敗した場合：エラー内容を持ったまま新規作成画面を再表示
      flash.now[:alert] = "カルテの作成に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
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
