class ApplicationController < ActionController::Base
  # Deviseの処理を行うときだけ、追加のパラメーター許可メソッドを呼ぶ
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録（sign_up）時に name の受け取りを許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # アカウント更新（account_update）時にも name の変更を許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end