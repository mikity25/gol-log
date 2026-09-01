require 'rails_helper'

RSpec.describe 'パスワードリセット', type: :system do
  let!(:user) { create(:user, email: 'reset_user@example.com', password: 'password123', password_confirmation: 'password123') }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe 'パスワード再設定フロー' do
    it '正しいメールアドレスを入力すると再設定メールが送信され、パスワードを変更してログインできること' do
      # 1. 申請画面へアクセス
      visit new_user_password_path
      expect(page).to have_content 'パスワードの再設定'

      # 2. メールアドレスを入力して申請
      fill_in 'メールアドレス', with: user.email
      click_button '再設定メールを送信する'

      # 3. 完了メッセージとログイン画面への遷移確認
      expect(page).to have_content 'パスワード再設定の手順を記載したメールを送信しました。'
      expect(page).to have_current_path new_user_session_path

      # 4. 送信メールの確認
      expect(ActionMailer::Base.deliveries.size).to eq 1
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include user.email

      # 5. メール本文（テキストパート優先）からトークンを抽出して遷移
      mail_body = mail.text_part ? mail.text_part.body.decoded : mail.body.decoded
      token = mail_body[/reset_password_token=([a-zA-Z0-9_\-]+)/, 1]
      visit edit_user_password_path(reset_password_token: token)

      # 6. 新しいパスワードの入力・更新
      expect(page).to have_content '新しいパスワードの設定'
      fill_in '新しいパスワード', with: 'new_password123'
      fill_in '新しいパスワード（確認用）', with: 'new_password123'
      click_button 'パスワードを変更する'

      # 7. 更新完了メッセージとトップ画面への遷移確認
      expect(page).to have_content 'パスワードが正しく変更されました。ログインしました。'
      expect(page).to have_current_path root_path
    end

    it '登録されていないメールアドレスを入力した場合でも、登録有無を特定させない案内メッセージが表示されメールが送信されないこと' do
      visit new_user_password_path

      fill_in 'メールアドレス', with: 'unknown_user@example.com'
      click_button '再設定メールを送信する'

      # アカウント列挙対策（paranoidモード）のメッセージ確認
      expect(page).to have_content 'メールアドレスが登録されている場合、パスワード再設定の手順を記載したメールを送信しました。'
      expect(page).to have_current_path new_user_session_path
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end
  end
end
