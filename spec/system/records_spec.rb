require 'rails_helper'

RSpec.describe 'カルテ管理機能', type: :system do
  let(:user) { create(:user) }
  let!(:record) { create(:record, user: user, golf_course_name: 'テストカントリークラブ', memo: 'アプローチが冴えていた') }

  before do
    login_as(user, scope: :user)
  end

  describe 'カルテ一覧・詳細表示' do
    it '作成済みのカルテが一覧画面に表示されること' do
      visit records_path
      expect(page).to have_content('テストカントリークラブ')
    end

    it 'カルテの詳細画面が表示できること' do
      visit record_path(record)
      expect(page).to have_content('テストカントリークラブ')
      expect(page).to have_content('アプローチが冴えていた')
    end
  end

  describe 'カルテの新規作成' do
    it '必須項目と任意項目を入力してカルテを作成できること' do
      visit new_record_path

      # 基本情報（同日重複を避けるため別のゴルフ場名を入力）
      fill_in 'ゴルフ場名', with: '新規テストカントリークラブ'
      fill_in 'プレー日', with: Date.current
      choose 'record_satisfaction_star4'

      # 料金・食事（任意：完全一致で「美味しい」チップをクリック）
      fill_in '総額料金（円）', with: 11500
      fill_in 'プランメモ', with: 'WEB優待料金'
      find('label', exact_text: '美味しい').click

      # スコア・ラウンド環境（任意：天気チップ選択）
      fill_in '18H スコア', with: 92
      find('label', exact_text: '晴れ').click

      # お風呂評価（任意：お風呂チップ選択）
      find('label', exact_text: '大満足').click

      # メモ（任意）
      fill_in 'record_memo', with: '天候に恵まれて楽しく回れた'

      # フォーム送信
      find('input[type="submit"]').click

      expect(page).to have_content('ゴルフカルテを作成しました')
      expect(page).to have_content('新規テストカントリークラブ')
    end

    it '必須項目が空の場合は作成に失敗し、エラーメッセージが表示されること' do
      visit new_record_path

      # 必須項目を入力せずに送信
      find('input[type="submit"]').click

      # 日本語のフラッシュメッセージと画面上のエラー案内を検証
      expect(page).to have_content 'カルテの作成に失敗しました'
      expect(page).to have_content '入力内容を確認してください'
    end
  end

  describe 'カルテの削除' do
    it 'カルテを削除できること' do
      visit record_path(record)

      if page.has_link?('削除')
        click_link '削除'
      else
        click_button '削除'
      end

      expect(page).to have_content('ゴルフカルテを削除しました')
      expect(page).not_to have_content('アプローチが冴えていた')
    end
  end
end