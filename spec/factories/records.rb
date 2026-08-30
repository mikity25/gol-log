FactoryBot.define do
  factory :record do
    # 持ち主となるユーザーを自動作成して紐付け
    association :user

    # 必須項目
    golf_course_name { "テストカントリークラブ" }
    played_on { Date.current }
    satisfaction { "star4" } # フォームのラジオボタン値（star1〜star5）

    # 任意項目（18H標準）
    score_18h { 90 }
    score_9h { nil }
    total_cost { 12000 }
    weather { "晴れ" }
    memo { "ドライバーが好調だった。" }

    # 9ホール（ハーフ）用の切り替え設定（Trait）
    trait :half_play do
      score_18h { nil }
      score_9h { 45 }
    end
  end
end
