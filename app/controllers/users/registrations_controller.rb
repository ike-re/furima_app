# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    unless @user.valid?
      flash.now[:alert] = @user.errors.full_messages
      render :new and return
    end
    session["devise.regist_data"] = { user: @user.attributes }
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    @deliver_address = @user.build_deliver_address
    render :new_deliver_address
  end

  def create_deliver_address
    @user = User.new(session["devise.regist_data"]["user"])
    params[:deliver_address][:phone_number] = nil if params[:deliver_address][:phone_number].blank?
    @deliver_address = DeliverAddress.new(deliver_address_params)
    unless @deliver_address.valid?
      flash.now[:alert] = @deliver_address.errors.full_messages
      render :new_deliver_address and return
    end
    @user.build_deliver_address(@deliver_address.attributes)
    @user.save
    sign_in(:user, @user)
    redirect_to root_path
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [])
    # end

    def deliver_address_params
      params.require(:deliver_address).permit(:post_code, :prefecture_code,
                                              :city, :house_number, :building_name,
                                              :destination_family_name, :destination_first_name,
                                              :destination_family_name_kana, :destination_first_name_kana,
                                              :phone_number)
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
