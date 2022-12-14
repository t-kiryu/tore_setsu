# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # ログイン前に退会済みユーザーかprotectedと合わせて確認
  before_action :customer_state, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  def after_sign_in_path_for(resource)
    flash[:notice] = "ご利用ありがとうございます"
    customers_my_page_path
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = "またのご利用をお待ちしております"
    root_path
  end

  protected

  #退会済み会員のログイン防止処理
  def customer_state
    @customer = Customer.find_by(email: params[:customer][:email])
    return if !@customer
    if @customer.valid_password?(params[:customer][:password]) && @customer.is_deleted == true
      flash[:error] = "退会済み情報のためご利用になれません"
      redirect_to new_customer_registration_path
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
