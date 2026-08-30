require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    # テストごとに新しい仮ユーザーを用意する
    let(:user) { build(:user) }

    context '正常系（合格パターン）' do
      it '必要な情報が正しく揃っていれば有効であること' do
        expect(user).to be_valid
      end
    end

    context 'メールアドレスのバリデーション' do
      it 'メールアドレスが空の場合は無効であること' do
        user.email = ''
        expect(user).to be_invalid
        expect(user.errors[:email]).to be_present
      end

      it 'すでに登録されているメールアドレスは重複して登録できないこと' do
        create(:user, email: 'duplicate@example.com')
        another_user = build(:user, email: 'duplicate@example.com')
        expect(another_user).to be_invalid
        expect(another_user.errors[:email]).to be_present
      end
    end

    context 'パスワードのバリデーション' do
      it 'パスワードが空の場合は無効であること' do
        user.password = ''
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end

      it 'パスワードが6文字未満（5文字以下）の場合は無効であること' do
        user.password = '12345'
        user.password_confirmation = '12345'
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end

      it 'パスワードと確認用パスワードが一致しない場合は無効であること' do
        user.password_confirmation = 'different_password'
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to be_present
      end
    end
  end
end
