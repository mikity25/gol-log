FactoryBot.define do
  factory :user do
    # 連番で被らないメールアドレスを自動生成
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
