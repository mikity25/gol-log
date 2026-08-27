class RecordsController < ApplicationController
  # ログインしていない人がアクセスしたらログイン画面へリダイレクト
  before_action :authenticate_user!

  def new
    @record = Record.new
  end
end