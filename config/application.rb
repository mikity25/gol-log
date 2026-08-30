require_relative "boot"

require "rails/all"

# Gemfile に記載された Gem を一括読み込み（環境別グループ含む）
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Rails 8.1 のデフォルト設定を読み込み
    config.load_defaults 8.1

    # lib ディレクトリ以下の自動読み込み設定（不要な assets や tasks は除外）
    config.autoload_lib(ignore: %w[assets tasks])

    # ----------------------------------------------------
    # 地域・言語・タイムゾーン設定
    # ----------------------------------------------------
    # アプリケーションのタイムゾーンを日本時間に設定
    config.time_zone = "Tokyo"

    # デフォルトの言語（ロケール）を日本語に設定
    config.i18n.default_locale = :ja

    # config/locales ディレクトリ以下のネストされた辞書ファイルも読み込む設定
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]
  end
end
