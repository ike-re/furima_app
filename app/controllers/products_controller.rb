class ProductsController < ApplicationController
  before_action :authenticate_user!, only: :new
  before_action :find_product, only: [:show, :edit, :update, :purchase, :destroy]
  before_action :admin_seller, only: [:edit, :destroy]

  def index
    @products = Product.includes(:photos).order(created_at: :desc).limit(5)
  end

  def show
    @products = Product.all
    if @product == @products.first
      @next_product = Product.next_search(@product)
    elsif @product == @products.last
      @prev_product = Product.prev_search(@product)
    else
      @prev_product = Product.prev_search(@product)
      @next_product = Product.next_search(@product)
    end
    @grandchild = Category.find(@product.category_id)
    @child = @grandchild.parent
    @parent = @child.parent
    @parent_category_products = @products.select { |product| product.category.root.name == @parent.name }
    @user = current_user
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    @card = CreditCard.find_by(user_id: current_user)
  end

  def new
    @product = Product.new
    @parents = Category.set_parents
    @photos =  @product.photos.build
    @brand = @product.build_brand
  end

  def destroy
    if @product.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  def create
    @product = Product.new(product_params)
    @product.brand.destroy if product_params[:brand_attributes][:name].blank?
    @product.category_id = nil if @product.category && @product.category.children?
    unless @product.valid?
      flash.now[:alert] = @product.errors.full_messages
      @parents = Category.set_parents
      @photos =  @product.photos.build
      @brand = @product.build_brand
      render :new and return
    end
    @product.save
    redirect_to user_path(current_user)
  end

  def update
    @grandchild = Category.find(@product.category_id)
    category =  Category.find_by(id: product_params[:category_id])
    if category && category.children?
      product_params[:category_id] = nil
    end
    brand_name = params[:product][:brand_attributes][:name]
    unless brand_name.empty?
      if @product.update(product_params)
        if params[:destroy_photo_id].present?
          params[:destroy_photo_id].each do |i|
            photo = Photo.find(i)
            if photo.product_id == @product.id
              photo.destroy
            end
          end
        end
        redirect_to user_path(current_user)
      else
        flash.now[:alert] = @product.errors.full_messages
        @parents = Category.set_parents
        @child = @grandchild.parent
        @parent = @child.parent
        @grandchildren = @child.children
        @children = @parent.children
        @prev_images = @product.photos.order(created_at: "ASC")
        @photos =  @product.photos.build
        unless @product.brand.nil?
          brand_name = @product.brand.name
        end
        @brand = @product.build_brand
        render :edit and return
      end
    else
      params[:product].delete(:brand_attributes)
      if @product.update(product_params)
        if params[:destroy_photo_id].present?
          params[:destroy_photo_id].each do |i|
            photo = Photo.find(i)
            if photo.product_id == @product.id
              photo.destroy
            end
          end
        end
        unless @product.brand.nil?
          @product.brand.destroy
          @product.update_attribute(:brand_id, nil)
        end
        redirect_to user_path(current_user)
      else
        flash.now[:alert] = @product.errors.full_messages
        @parents = Category.set_parents
        @child = @grandchild.parent
        @parent = @child.parent
        @grandchildren = @child.children
        @children = @parent.children
        @prev_images = @product.photos.order(created_at: "ASC")
        @photos =  @product.photos.build
        unless @product.brand.nil?
          @brand_name = @product.brand.name
        end
        @brand = @product.build_brand
        render :edit and return
      end
    end
  end

  def edit
    @parents = Category.set_parents
    @grandchild = Category.find(@product.category_id)
    @child = @grandchild.parent
    @parent = @child.parent
    @grandchildren = @child.children
    @children = @parent.children
    @prev_images = @product.photos.order(created_at: "ASC")
    @photos =  @product.photos.build
    unless @product.brand.nil?
      @brand_name = @product.brand.name
    end
    @brand = @product.build_brand
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

  def purchase
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    @card = CreditCard.find_by(user_id: current_user)
    if @card.blank?
      redirect_to new_credit_card_path
    else
      @customer = Payjp::Customer.retrieve(@card.customer_id)
      @card_information = @customer.cards.retrieve(@card.card_id)
      @deliver_address = current_user.deliver_address
    end
  end

  def pay
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    @card = CreditCard.find_by(user_id: current_user.id)
    if @card.blank?
      redirect_to new_credit_card_path
    else
      @product = Product.find(params[:id])
      unless @product.buyer_id.nil?
        redirect_to purchase_product_path(@product) and return
      end
      @product.update(buyer_id: current_user.id, trading_status: 2)
      Payjp::Charge.create(
        :amount => @product.price, 
        :customer => @card.customer_id,
        :currency => 'jpy',
      )
      redirect_to paid_products_path
    end
  end

  def search
    @parents = Category.set_parents
    if params[:keyword]
      params[:q] = { sorts: 'id desc' }
      @search = Product.ransack()
      @products = Product.key_search(params[:keyword]).page(params[:page]).order(params[:q][:sorts])
    else
      if params[:q].present?
        if search_params[:category_id_in].present?
          @search = Product.ransack(search_params)
          @products = @search.result.page(params[:page]).order(params[:q][:sorts])
        elsif params[:product] && Category.find_by(id: product_params[:category_id]).present?
          category_id_hash = { category_id_in: Category.find(product_params[:category_id]).child_ids }
          search_params = params[:q].merge(category_id_hash)
          @search = Product.ransack(search_params)
          @products = @search.result.page(params[:page]).order(params[:q][:sorts])
        elsif Category.find_by(id: params[:q][:category_id]).present?
          category_id_hash = { category_id_in: Category.find(params[:q][:category_id]).indirect_ids }
          search_params = params[:q].merge(category_id_hash)
          @search = Product.ransack(search_params)
          @products = @search.result.page(params[:page]).order(params[:q][:sorts])
        else
          @search = Product.ransack(search_params)
          @products = @search.result.page(params[:page]).order(params[:q][:sorts])
        end
      else
        params[:q] = { sorts: 'id desc' }
        @search = Product.ransack()
        @products = Product.all.page(params[:page]).order(params[:q][:sorts])
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

    def search_params
      params.require(:q).permit(:sorts, :name_cont, :brand_name_cont,
                                :size_id_eq, :price_gteq, :price_lteq,
                                trading_status_in: [], condition_id_in: [],
                                postage_payer_id_in: [], category_id_in: []
                                )
    end

    def find_product
      @product = Product.find(params[:id])
    end

    def admin_seller
      unless current_user.id == @product.seller_id
        redirect_to product_path
      end
    end
end