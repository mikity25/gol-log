class Record < ApplicationRecord
  # ユーザーとの紐付け（必須）
  belongs_to :user

  # 満足度のenum設定（星1〜星5）
  enum :satisfaction, { star1: 1, star2: 2, star3: 3, star4: 4, star5: 5 }

  # 必須項目のバリデーション（空欄チェック）
  validates :golf_course_name, presence: true
  validates :played_on, presence: true
  validates :satisfaction, presence: true

  # 重複チェック（同じユーザーが、同じ日に、同じゴルフ場を二重登録するのを防ぐ）
  validates :golf_course_name, uniqueness: {
    scope: [ :user_id, :played_on ],
    message: "は同じ日にすでに登録されています"
  }

  # 自動計算トリガー（保存の直前に計算機を動かす）
  before_save :calculate_converted_score_18h

  private

  # 9Hスコアを2倍して18H換算スコアにセットする計算機
  def calculate_converted_score_18h
    if score_9h.present?
      self.converted_score_18h = score_9h * 2
    else
      self.converted_score_18h = nil
    end
  end
end
