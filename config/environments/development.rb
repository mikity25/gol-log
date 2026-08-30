require "active_support/core_ext/integer/time"

Rails.application.configure do
  # ----------------------------------------------------
  # 開発効率アップ・自動読み込み設定
  # ----------------------------------------------------
  # コードを変更したらサーバー再起動なしで即座に反映
  config.enable_reloading = true

  # 起動時にすべてのコードを一括読み込みしない（起動速度を優先）
  config.eager_load = false

  # エラー発生時に詳細なデバッグ用エラー画面を表示する
  config.consider_all_requests_local = true

  # 処理速度（サーバータイミング）の測定を有効化
  config.server_timing = true

  # ----------------------------------------------------
  # キャッシュ・ストレージ設定
  # ----------------------------------------------------
  # 開発環境でのコントローラーキャッシュ制御（tmp/caching-dev.txt の有無で切替）
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end

  # キャッシュ保存先をメモリ上に設定（手軽で高速）
  config.cache_store = :memory_store

  # 画像などのファイル保存先をローカルディスクに設定
  config.active_storage.service = :local

  # ----------------------------------------------------
  # メール設定（開発用）
  # ----------------------------------------------------
  # メール送信に失敗しても例外エラーを発生させない
  config.action_mailer.raise_delivery_errors = false

  # メールテンプレートのキャッシュを無効化（編集を即反映）
  config.action_mailer.perform_caching = false

  # メール内のリンク生成時に使用するデフォルトURL（localhost:3000）
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # ----------------------------------------------------
  # ログ・デバッグ設定
  # ----------------------------------------------------
  # 非推奨な記法（Deprecation）の警告を Rails ログに出力
  config.active_support.deprecation = :log

  # 未実行のマイグレーションがある場合、アクセス時にエラー画面で通知
  config.active_record.migration_error = :page_load

  # 実行されたSQLログに、呼び出し元のコード行数を表示（原因追究を容易に）
  config.active_record.verbose_query_logs = true

  # SQLログに実行タグ（コントローラー名等）を自動付与
  config.active_record.query_log_tags_enabled = true

  # バックグラウンドジョブ呼び出し時の詳細ログを出力
  config.active_job.verbose_enqueue_logs = true

  # リダイレクト発生時の詳細ログを出力
  config.action_dispatch.verbose_redirect_logs = true

  # 画像やCSSなどアセットファイルへのリクエストログを省略（ログを見やすく整理）
  config.assets.quiet = true

  # 表示されたビュー（HTML）のソースに元ファイル名を注記
  config.action_view.annotate_rendered_view_with_filenames = true

  # 存在しないアクションへのコールバック指定時にエラーを発生（タイポ防止）
  config.action_controller.raise_on_missing_callback_actions = true

  # ----------------------------------------------------
  # Bullet（N+1問題検出ツール）の設定
  # ----------------------------------------------------
  config.after_initialize do
    Bullet.enable        = true # Bullet を有効化（見張りスイッチON）
    Bullet.alert         = true # ブラウザ上に警告ポップアップを表示
    Bullet.bullet_logger = true # log/bullet.log に警告内容を記録
    Bullet.console       = true # ブラウザのコンソール（F12）に警告を出力
    Bullet.rails_logger  = true # ターミナルの Rails ログに警告を出力
  end
end
