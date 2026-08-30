require 'rails_helper'

RSpec.describe Record, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }

    context '正常系（合格パターン）' do
      it '18Hの必須情報が揃っていれば登録できること' do
        record = build(:record, user: user)
        expect(record).to be_valid
      end

      it '9H（ハーフ）の必須情報が揃っていれば登録できること' do
        record = build(:record, :half_play, user: user)
        expect(record).to be_valid
      end
    end

    context '基本情報（必須項目）のバリデーション' do
      it 'ゴルフ場名が空の場合は登録できないこと' do
        record = build(:record, user: user, golf_course_name: '')
        expect(record).to be_invalid
        expect(record.errors[:golf_course_name]).to be_present
      end

      it 'プレー日が空の場合は登録できないこと' do
        record = build(:record, user: user, played_on: nil)
        expect(record).to be_invalid
        expect(record.errors[:played_on]).to be_present
      end

      it '総合満足度が空の場合は登録できないこと' do
        record = build(:record, user: user, satisfaction: nil)
        expect(record).to be_invalid
        expect(record.errors[:satisfaction]).to be_present
      end
    end

    context '同一ユーザーの同日・同ゴルフ場重複防止バリデーション' do
      it '同じユーザーが同日・同ゴルフ場で重複登録しようとした場合は登録できないこと' do
        create(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.current)
        duplicate_record = build(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.current)
        expect(duplicate_record).to be_invalid
        expect(duplicate_record.errors[:golf_course_name]).to include('は同じ日にすでに登録されています')
      end

      it '別の日付であれば同じゴルフ場名でも登録できること' do
        create(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.current)
        another_day_record = build(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.yesterday)
        expect(another_day_record).to be_valid
      end
    end

    context '料金（total_cost）のバリデーション' do
      it 'マイナスの料金は登録できないこと' do
        record = build(:record, user: user, total_cost: -1000)
        expect(record).to be_invalid
        expect(record.errors[:total_cost]).to be_present
      end
    end

    context 'スコア入力のバリデーション' do
      it '18Hスコアと9Hスコアが両方入力されている場合は登録できないこと' do
        record = build(:record, user: user, score_18h: 90, score_9h: 45)
        expect(record).to be_invalid
        expect(record.errors[:base]).to include('スコアは「18Hスコア」または「9Hスコア」のどちらか一方のみ入力してください')
      end
    end

    context '自動計算・換算ロジック' do
      it '9Hスコア入力時に18H換算スコア（2倍）が自動計算されて保存されること' do
        record = create(:record, :half_play, user: user, score_9h: 44)
        expect(record.converted_score_18h).to eq(88)
      end

      it '18Hスコア入力時は換算スコアがnilになること' do
        record = create(:record, user: user, score_18h: 90, score_9h: nil)
        expect(record.converted_score_18h).to be_nil
      end
    end
  end
end
