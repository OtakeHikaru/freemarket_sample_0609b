require 'rails_helper'
describe ProductsController do
  let(:user) { create(:user) }
  before do
    grandchildren = []
    grandchildren << build(:category, category: "Tシャツ/カットソー", parent_id: "14")
    grandchildren << build(:category, category: "ポロシャツ", parent_id: "14")
    grandchildren << build(:category, category: "パーカー", parent_id: "14")
    allow(Category).to receive(:get_all_grandchildren).and_return(grandchildren)
  end
     describe 'GET #index' do
    it 'indexアクションで出品中のアイテムのみが表示されるか' do
       product = FactoryBot.create(:product)
       get :index, params: { product_status_id: product }
       expect(assigns(:product)).to match [product.product_status_id == 1]
     end

  describe 'GET #new' do
    context 'log in' do
      before do
        login_user user
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    context 'not log in' do
      it "redirects to new_user_session_path" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'log in' do
      before do
       login_user user
      end
      it "assigns the requested product to @product" do
        product = create(:product)
        get :edit, params: { id: product }
        expect(assigns(:product)).to eq product
      end

      it "renders the :edit template" do
        product = create(:product)
        get :edit, params: { id: product }
        expect(response).to render_template :edit
      end
    end

    context 'not log in' do
      it "redirects to new_user_session_path" do
        product = create(:product)
        get :edit, params: { id: product }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let(:params) { { product: attributes_for(:product) } }
    subject {
      post :create,
      params: params
    }
    before do
      login_user user
    end
    context 'can save' do
      it 'count up product' do
        params[:product][:images_attributes] = [ attributes_for(:image, product: params) ]
        params[:product][:purchase_attributes] = attributes_for(:purchase, product: params, seller_id: user.id)
        expect{ subject }.to change(Product, :count).by(1).and change(Image, :count).by(1).and change(Purchase, :count).by(1)
      end

      it 'redirects to root_path' do
        subject
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:product) { create(:product) }
    let(:new_product) { attributes_for(:product, name: 'hoge', description: 'hogehoge') }
    before do
      login_user user
    end
    context 'can update' do
      it "locates the requersted @product" do
        patch :update, params: {id: product.id, product: attributes_for(:product)}
        expect(assigns(:product)).to eq product
      end

      it "changes @product's attributes" do
        patch :update, params: {id: product.id, product: attributes_for(:product, name: 'hoge', description: 'hogehoge')}
        product.reload
        expect(product.name).to eq("hoge")
        expect(product.description).to eq("hogehoge")
      end

      it "changes @product's attributes with @image" do
        new_product[:images_attributes] = [ attributes_for(:image, product: product, image: 'hogehoge') ]
        expect {
          patch :update, params: {id: product.id, product: new_product}
        }.to change(Image, :count).by(1)
      end

      it 'destroy images with product' do
        product.images.create
        expect{ product.destroy }.to change{ Image.count }.by(-1)
      end

      it "redirects to products_path" do
        patch :update, params: {id: product.id, product: attributes_for(:product)}
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
