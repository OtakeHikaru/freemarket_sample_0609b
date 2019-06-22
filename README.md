# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 
2.5.1

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Design Database

## productsテーブル(商品)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|name|varchar|null: false, index: true|
|description|varchar|null: false|
|price|bigdecimal|null: false|
|condition|integer|null: false, foreign_key: true|
|brand|integer|null: false, foreign_key: true|
|shipping_fee_pay|integer|null: false, foreign_key: true|
|shipping_off_area|integer|null: false, foreign_key: true|
|shipping_off_day|integer|null: false, foreign_key: true|
|product_status|integer|foreign_key: true|
|user|integer|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :condition
- belongs_to :shipping_fee_pay
- belongs_to :shipping_off_area
- belongs_to :shipping_off_day
- belongs_to :category
- belongs_to :brand
- belongs_to :product_status
- has_one :report, dependent: :destroy
- has_many :comments, dependent: :destroy
- has_many :product_pictures, dependent: :destroy
- has_many :likes, dependent: :destroy
- has_many :users, through: :likes
- has_many :purchases
- has_one :sellers, through: :purchases
- has_one :buyers, through: :purchases

## product_picturesテーブル(商品写真)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|product_picture|integer|
|product|integer|null: false,foreign_key: true|
### Association
- belongs_to :product 

## brandsテーブル（ブランド）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|brand_name|varchar|null: false, unique: true|
|l_category|integer|null: false, foreign_key: true|
### Association
- has_many :products
- belongs_to :l_category

## conditionsテーブル（商品状態）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|condition||varchar|null: false, unique: true|
### Association
- has_many :products

## sizesテーブル(サイズ４タイプ・サイズ）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|size|varchar|null: false|
|size_type|varchar|null: false,foreign_key: true|
### Association
- has_many :products
- belongs_to :size_type

## size_typesテーブル(大人服・子供服・大人靴・子供靴)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|size_type|varchar|null: false|
### Association
- has_many :sizes

## categorysテーブル(LMSサイズカテゴリの隣接リスト)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|size|integer|null: false, foreign_key: true|
|l_category|integer|null: false, foreign_key: true|
|m_category|integer|foreign_key: true|
|s_category|integer|foreign_key: true|
|parent|integer|
|brand_exist|boolean|default: false|
###### 木構造の参考サイト
https://qiita.com/chopin3/items/ca5525406ef005086e59
https://jvvg0oynveolxikm.qrunch.io/entries/3JG4bNOVyRgNxVGt
https://techracho.bpsinc.jp/hira/2018_03_15/53872r
### Association
- has_many :products
- belongs_to :parent, class_name: :Category
- has_many :children, class_name: :Category, foreign_key: :parent_id

## delivery_fee_paysテーブル（配送料負担）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|delivery_fee_pay|varchar|null: false|
### Association
- has_many :products

## delivery_waysテーブル（配送方法）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|delivery_way|varchar|null: false|
### Association
- has_many :products

## shipping_off_daysテーブル（配送日数）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|shipping_off_day|varchar|null: false|
### Association
- has_many :products

## shipping_off_areasテーブル（発送地域）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|shipping_off_area|varchar|null: false|
### Association
- has_many :products

## likesテーブル（いいね！）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|likes_count|integer|null: false|
|user|integer|null: false, foreign_key: true|
|product|integer|null: false,foreign_key: true|
###### いいねの実装参考サイト
https://qiita.com/shiro-kuro/items/f017dce3d199f06d1dcd
### Association
- belongs_to :product, counter_cache: :likes_count
- belongs_to :user

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|nickname|varchar|null: false|
|email|integer|null: false, unique: true|
|password|varchar|null: false|
|region|integer|null: false,foreign_key: true|
|family_name|varchar|null: false|
|first_name|varchar|null: false|
|family_name_kana|varchar|null: false|
|first_name_kana|varchar|null: false|
|birth|date|null: false|
|gender|integer|null: false|
|sms_authentication|integer|null: false, unique: true|
###### 商品取引関連付けの参考サイト
http://www.coma-tech.com/archives/223/
### Association
- has_one :user_detail, dependent: :destroy
- has_one :region, dependent: :destroy
- has_many :products, dependent: :destroy
- has_many :likes, dependent: :destroy
- has_many :credit_cards, dependent: :destroy
- has_many :comments, dependent: :destroy
- has_many :user_deliverys, dependent: :destroy
- has_many :purchases_of_seller, class_name: 'Purchase', foreign_key: 'seller_id'
- has_many :purchases_of_buyer, class_name: 'Purchase', foreign_key: 'buyer_id'
- has_many :products_of_seller, through: :products_of_seller, source: 'product'
- has_many :products_of_buyer, through: :productss_of_buyer, source: 'product'
- has_many :reports, dependent: :destroy
- has_many :sns_credentials, dependent: :destroy

## sns_credentialテーブル（facebook/google認証）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|name|varchar|
|nickname|varchar|
|email|integer|unique: true|
|provider|integer|
|url|varchar|
|image_url|varchar|
|uid|integer|
|token|varchar|
|other|text|
|user|integer|null: false,foreign_key: true|
###### google・facebookユーザ認証の参考サイト
https://qiita.com/bino98/items/596b5cffeca7c104bd90
### Association
- belongs_to :user, optional: true


## user_detailsテーブル（ユーザ詳細情報）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|zip_code|integer|null: false|
|city|varchar|null: false|
|street|varchar|null: false|
|building_name|varchar|
|avatar_image|varchar|
|avatar_text|varchar|
|region|varchar|null: false,foreign_key: true|
|user|integer|null: false,foreign_key: true|
### Association
- belongs_to :user
- belongs_to :region

## regionテーブル(都道府県)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|region_name|varchar|null: false|
### Association
- has_many :users
- has_many :user_deliverys

## user_deliverysテーブル（ユーザ配送情報）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|ship_family_name|varchar|null: false|
|ship_first_name|varchar|null: false|
|ship_family_name_kana|varchar|null: false|
|ship_first_name_kana|varchar|null: false|
|zip_code|integer|null: false|
|region|varchar|null: false,foreign_key: true|
|city|varchar|null: false|
|street|varchar|null: false|
|building_name|varchar|
|phone|integer|
|user|integer|null: false,foreign_key: true|
### Association
- has_many :purchases
- belongs_to :user
- belongs_to :region

## Credit_cardsテーブル（クレジットカード）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|card_number|integer|null: false|
|card_month|integer|null: false|
|card_year|integer|null: false|
|security_code|integer|null: false|
|user|integer|null: false,foreign_key: true|
### Association
- has_many :purchases
- belongs_to :user

## reportsテーブル(受取評価/被評価ユーザーID)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|comment|varchar|ull: false|
|user|integer|null: false,foreign_key: true|
|product|integer|null: false,foreign_key: true|
### Association
- belongs_to :reputation_type
- belongs_to :perchase
- belongs_to :user
- belongs_to :product

## reputation_typesテーブル(良い/普通/悪い)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|reputation_type|varchar|
### Association
- has_many :reports 

## commentsテーブル（コメント）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|comment|varchar|null: false|
|time|daytime|null: false|
|user|integer|null: false,foreign_key: true|
|product|integer|null: false,foreign_key: true|
### Association
- belongs_to :product 
- belongs_to :user

## perchasesテーブル(取引)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|payment|bigdecimal|
|profit|bigdecimal|foreign_key: true|
|user|integer|null: false,foreign_key: true|
|credit_card|integer|null: false,foreign_key: true|
|user_delivery|integer|null: false,foreign_key: true|
|buyer_user|integer|foreign_key: true|
|seller_user|integer|null: false,foreign_key: true|
|product|integer|null: false,foreign_key: true|
###### 商品取引関連付けの参考サイトhttp://www.coma-tech.com/archives/223/
### Association
- has_one :report
- belongs_to :user
- belongs_to :credit_card
- belongs_to :user_delivery
- belongs_to :seller, class_name: 'User'
- belongs_to :buyer, class_name: 'User'
- belongs_to :product

## pointsテーブル（保有ポイント）
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|point|bigdecimal|
|user|integer|null: false,foreign_key: true|
###### 1ポイント=1円として商品を購入するときに利用できます。
### Association
- belongs_to :user

## remindsテーブル(やることリスト)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|remind|varchar|
|user|integer|null: false,foreign_key: true|
|product|integer|null: false,foreign_key: true|
### Association
- belongs_to :user
- belongs_to :product 

## profitsテーブル(売上金)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|profit|bigdecimal|null: false,foreign_key: true|
|user|integer|null: false,foreign_key: true|
|product|integer|null: false,foreign_key: true|
### Association
- has_one :purchase
- belongs_to :user
- belongs_to :product

## product_statusテーブル(出品中/売り切れ/出品削除)
|Column|Type|Options|
|------|----|-------|
|id|integer|primary key|
|product_status|varchar|null: false|
### Association
- has_many :product


