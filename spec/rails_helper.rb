# SimpleCov（必ず一番上に置くこと）
require 'simplecov'
SimpleCov.start 'rails' do
  # 測定対象から外すフォルダ
  add_filter '/spec/'
  add_filter '/config/'
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner/active_record'

# spec/support 配下のモジュール（ログインヘルパーやカスタムマクロ等）を自動読み込み
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!

  # FactoryBot の構文（create, build）を省略して直接呼び出せるように設定
  config.include FactoryBot::Syntax::Methods

  # DatabaseCleaner によるテスト実行前後のDB初期化・データ分離設定
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end