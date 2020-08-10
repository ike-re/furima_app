class CreditCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_api_key, only: [:edit, :create, :show, :delete]

  require "payjp"

  def new
    @card = CreditCard.new
    card = CreditCard.where(id: params[current_user.id])
    redirect_to credit_card_path if card.exists?
  end
  
  def edit
  end

  def create
    if params['payjp-token'].blank?
      redirect_to new_credit_card_path
    else
      customer = Payjp::Customer.create(
        description: '登録テスト',
        email: current_user.email,
        card: params['payjp-token'],
        metadata: {user_id: current_user.id}
      )
      @card = CreditCard.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        flash[:notice] = 'クレジットカードを登録しました'
        redirect_to root_path
      else
        flase[:alert] = 'クレジットカードが正しく登録できませんでした'
        render :create
      end
    end
  end

  def delete
    @card = CreditCard.find_by(user_id: current_user.id)
    if @card.blank?
    else
      @customer = Payjp::Customer.retrieve(@card.customer_id)
      @customer.delete
      @card.delete
    end
      redirect_to new_credit_card_path
  end

  def show
    @card = CreditCard.find_by(user_id: current_user.id)
    if @card.blank?
      redirect_to new_credit_card_path
    else
      @customer = Payjp::Customer.retrieve(@card.customer_id)
      @card_information = @customer.cards.retrieve(@card.card_id)
      @default_card_information = @customer.cards.retrieve(@card.card_id)
    end
  end

  private 
  
  def set_api_key
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
  end
end
