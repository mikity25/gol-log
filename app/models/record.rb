class Record < ApplicationRecord
  belongs_to :user

  enum :satisfaction, { star1: 1, star2: 2, star3: 3, star4: 4, star5: 5 }

  # バリデーション
  validates :golf_course_name, presence: true
  validates :played_on, presence: true
  validates :satisfaction, presence: true

  # 同一ユーザーによる同日・同ゴルフ場の二重登録を防止
  validates :golf_course_name, uniqueness: {
    scope: [:user_id, :played_on],
    message: "は同じ日にすでに登録されています"
  }

  # 料金は0以上の半角整数のみ許可（任意入力）
  validates :total_cost, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true
  }

  # スコアは18Hまたは9Hのどちらか一方のみ許可
  validate :either_score_18h_or_score_9h

  # コールバック：保存直前に18H換算スコアを自動算出
  before_save :calculate_converted_score_18h

  private

  def either_score_18h_or_score_9h
    return unless score_18h.present? && score_9h.present?

    errors.add(:base, "スコアは「18Hスコア」または「9Hスコア」のどちらか一方のみ入力してください")
  end

  def calculate_converted_score_18h
    self.converted_score_18h = score_9h.present? ? score_9h * 2 : nil
  end
end