Rails.application.routes.draw do
  # Deviseのルーティング（ログイン・新規登録など）
  devise_for :users

  # アプリのルートURL（ / ）にアクセスした際、StaticPagesController の top アクションを表示する
  root "static_pages#top"

  # カルテの一覧・作成画面・保存処理の道を開通
  resources :records, only: %i[index new create]

  # ヘルスチェック用（Rails8標準設定）
  get "up" => "rails/health#show", as: :rails_health_check
end
