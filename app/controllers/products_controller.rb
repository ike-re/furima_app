class ProductsController < ApplicationController
  before_action :authenticate_user!, only: :new

  def index
  end

  def new
    @product = Product.new
    @parents = Category.where(ancestry: nil).order(id: "ASC")
    @photos =  @product.photos.build
    @brand = @product.build_brand
  end

  def create
    @product = Product.new(product_params)
    unless @product.valid?
      flash.now[:alert] = @product.errors.full_messages
      @parents = Category.where(ancestry: nil).order(id: "ASC")
      @photos =  @product.photos.build
      @brand = @product.build_brand
      render :new and return
    end
    @product.save
    redirect_to user_path(current_user)
  end

  def search_category_children
    respond_to do |format|
      format.html
      format.json do
        @children = Category.find(params[:parent_id]).children
      end
    end
  end

  def search_category_grandchildren
    respond_to do |format|
      format.html
      format.json do
        @grandchildren = Category.find(params[:child_id]).children
      end
    end
  end

  private
    def product_params
      params.require(:product).permit(:name, :introduction, :size_id,
                                      :condition_id, :postage_payer_id, :prefecture_code,
                                      :prep_date_id, :price, :trading_status,
                                      :closed_deal_date, :category_id,
                                      photos_attributes:[:image, :product_id],
                                      brand_attributes:[:name]
      ).merge(seller_id: current_user.id)
    end
end