class Record < ApplicationRecord
  # ユーザーとの紐付け（必須）
  belongs_to :user

  # 必須項目のバリデーション（空欄チェック）
  validates :golf_course_name, presence: true
  validates :played_on, presence: true
  validates :satisfaction, presence: true

  # 満足度のenum設定（星1〜星5）
  enum :satisfaction, { star1: 1, star2: 2, star3: 3, star4: 4, star5: 5 }
end
