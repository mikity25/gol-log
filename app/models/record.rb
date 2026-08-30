class Record < ApplicationRecord
  belongs_to :user

  # 配列カラムを自動でシリアライズ（配列として扱う）
  serialize :green_features, type: Array, coder: YAML
  serialize :driving_range, type: Array, coder: YAML
  serialize :bath_features, type: Array, coder: YAML
  serialize :plan_options, type: Array, coder: YAML

  enum :satisfaction, { star1: 1, star2: 2, star3: 3, star4: 4, star5: 5 }

  # 必須バリデーション
  validates :golf_course_name, presence: true
  validates :played_on, presence: true
  validates :satisfaction, presence: true

  # 同一ユーザーの同日・同ゴルフ場重複防止
  validates :golf_course_name, uniqueness: {
    scope: [:user_id, :played_on],
    message: "は同じ日にすでに登録されています"
  }

  # 料金は0以上の半角整数のみ（任意）
  validates :total_cost, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true
  }

  # スコア排他チェック
  validate :either_score_18h_or_score_9h

  # 18H換算自動計算
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