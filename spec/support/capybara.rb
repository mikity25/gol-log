RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # Warden/Devise の高速ログインヘルパー（login_as）を有効化
  config.include Warden::Test::Helpers, type: :system
  config.after(:each, type: :system) do
    Warden.test_reset!
  end
end
