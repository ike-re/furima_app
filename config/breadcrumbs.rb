crumb :root do
  link "トップページ", root_path
end

crumb :mypage do
  link "マイページ"
  parent :root
end

crumb :card do
  link "クレジットカード登録"
  parent :mypage
end

crumb :card_show do
  link "クレジットカード詳細"
  parent :mypage
end

crumb :products_new do
  link "商品出品"
  parent :root
end

crumb :products_show do
  link "商品詳細", product_path
  parent :root
end

crumb :products_edit do
  link "商品編集"
  parent :products_show
end

crumb :products_purchase do
  link "商品購入確認"
  parent :products_show
end