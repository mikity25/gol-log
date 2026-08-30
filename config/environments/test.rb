# テスト環境設定ファイル：テスト実行時のみ読み込まれ、テスト用DB（実行ごとに初期化）を使用

Rails.application.configure do
  # ----------------------------------------------------
  # テスト実行・自動読み込み設定
  # ----------------------------------------------------
  # テスト実行中にコードの変更を監視・自動リロードしない（テスト速度を優先）
  config.enable_reloading = false

  # CI環境（GitHub Actions等）では全コードを一括読み込み（本番相当の検証）、ローカルテスト時は不要
  config.eager_load = ENV["CI"].present?

  # ----------------------------------------------------
  # キャッシュ・ストレージ設定
  # ----------------------------------------------------
  # テスト用の静的ファイル配信時のキャッシュ制御
  config.public_file_server.headers = { "cache-control" => "public, max-age=3600" }

  # エラー発生時に詳細なレポートを表示
  config.consider_all_requests_local = true

  # テスト中はキャッシュを無効化（常に最新のデータを参照）
  config.cache_store = :null_store

  # Active Storage のファイル保存先をテスト用の一時ディレクトリに設定
  config.active_storage.service = :test

  # ----------------------------------------------------
  # コントローラー・セキュリティ設定
  # ----------------------------------------------------
  # 例外発生時のテンプレート描画設定
  config.action_dispatch.show_exceptions = :rescuable

  # テスト環境では CSRF 保護（トークン検証）を無効化（APIやフォームテストを円滑に）
  config.action_controller.allow_forgery_protection = false

  # 存在しないアクションへのコールバック指定時にエラーを発生（タイポ防止）
  config.action_controller.raise_on_missing_callback_actions = true

  # ----------------------------------------------------
  # メール設定（テスト用）
  # ----------------------------------------------------
  # 外部へメールを送信せず、メモリ内の配列（ActionMailer::Base.deliveries）に蓄積して検証可能にする
  config.action_mailer.delivery_method = :test

  # メール内リンク生成時に使用するデフォルトURL
  config.action_mailer.default_url_options = { host: "www.example.com" }

  # ----------------------------------------------------
  # ログ・非推奨警告設定
  # ----------------------------------------------------
  # 非推奨な記法（Deprecation）の警告を標準エラー出力（stderr）に出力
  config.active_support.deprecation = :stderr

  # 翻訳漏れ（Translation missing）が発生した際にエラーを発生させる（必要に応じて有効化）
  # config.i18n.raise_on_missing_translations = true

  # ビューのソースに元ファイル名を注記する（必要に応じて有効化）
  # config.action_view.annotate_rendered_view_with_filenames = true
end
