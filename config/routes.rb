Rails.application.routes.draw do
  # Deviseのルーティング（ログイン・新規登録など）
  devise_for :users

  # アプリのルートURL（ / ）にアクセスした際、StaticPagesController の top アクションを表示する
  root "static_pages#top"

  # ヘルスチェック用（Rails8標準設定）
  get "up" => "rails/health#show", as: :rails_health_check
end