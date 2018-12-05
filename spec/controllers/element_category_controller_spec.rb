require 'rails_helper'
require 'pry'

# DONE: figure out site access for element_category
# Role     Index   Show   Create   Update   Destroy
# Admin    Full    Full   Full     Full     Full
# Trainer  None    None   None     None     None
# NoLogin  None    None   None     None     None

RSpec.describe ElementCategoriesController, type: :controller do

  describe "administrator access" do

    before(:example) do
      set_user_session(create(:admin))
    end

    describe 'GET #index' do
      it "populates an array of element categories" do
        body_position = create(:body_position)
        angle = create(:angle)
        get :index
        expect(assigns(:element_categories)).to match_array([body_position, angle])
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end

      it "assigns a new Contact to @contact" do
        get :index
        expect(assigns(:new_category)).to be_a_new(ElementCategory)
      end
    end

    describe 'GET #edit' do
      it "assigns the requested contact to @contact" do
        category = create(:element_category)
        get :edit, params: { id: category }
        expect(assigns(:element_category)).to eq category
      end

      it "renders the :edit template" do
        category = create(:element_category)
        get :edit, params: { id: category }
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do

      context "with valid attributes" do
        it "saves a new contact in the database" do
            expect{ post :create, :params => {
              element_category: attributes_for(:element_category)
            }
          }.to change(ElementCategory, :count).by(1)
        end

        it "redirects to element_categories#index" do
          post :create, :params => {
            element_category: attributes_for(:element_category)
          }
          expect(response).to redirect_to(element_categories_path)
        end
      end

      context "with invalid attributes" do
        it "does not save a new contact in the database" do
          expect{ post :create, :params => {
            element_category: attributes_for(:invalid_category)
          }
        }.not_to change(ElementCategory, :count)
        end

        it "redirects to element_categories#index" do
          post :create, :params => {
            element_category: attributes_for(:invalid_category)
          }
          expect(response).to render_template :index
        end
      end

    end

    describe 'PATCH #update' do
      before(:example) do
        @element_category = create(:element_category,
          category_name: "Tool"
        )
      end

      context "valid attributes" do

        it "locates the requested @element_category" do
          patch :update, :params => {
            id: @element_category,
            element_category: attributes_for(:element_category,
              category_name: "Support"
            )
          }
          @element_category.reload
          expect(@element_category.category_name).to eq("Support")
        end

        it "changes @element_category's attributes" do
          patch :update, :params => {
            id: @element_category,
            element_category: attributes_for(:element_category)
          }
          expect(assigns(:contact)).to eq(@contact)
        end

        it "redirects to index" do
          patch :update, :params => {
            id: @element_category,
            element_category: attributes_for(:element_category)
          }
          expect(response).to redirect_to(element_categories_path)
        end

      end

      context "invalid attributes" do

        it "does not change @element_category's attributes" do
          patch :update, :params => {
            id: @element_category,
            element_category: attributes_for(:element_category,
              category_name: ""
            )
          }
          @element_category.reload
          expect(@element_category.category_name).not_to eq("")
        end

        it "redirects to index" do
          patch :update, :params => {
            id: @element_category,
            element_category: attributes_for(:invalid_category)
          }
          expect(response).to render_template(:edit)
        end

      end

    end

    describe'DELETE #destroy'do
    before :example do
      @element_category = create(:element_category)
    end

    it "deletes the category" do
      expect{
        delete :destroy, params: {id: @element_category}
      }.to change(ElementCategory,:count).by(-1)
    end

    it "redirects to element_category's#index" do
      delete :destroy, params: {id: @element_category}
      expect(response).to redirect_to element_categories_url
    end

    end

  end

  describe "Trainer access" do
    before(:example) do
      set_user_session(create(:user))
    end

    describe 'GET #index' do
      it "redirects to login_path" do
        get :index
        expect(response).to redirect_to(user_path(@user))
      end
    end

    describe 'GET #edit' do
      it "redirects to login_path" do
        category = create(:element_category)
        get :edit, params: { id: category }
        expect(response).to redirect_to(user_path(@user))
      end
    end

    describe 'POST #create' do
      it "redirects to login_path" do
        post :create, params: {element_category: attributes_for(:element_category)}
        expect(response).to redirect_to(user_path(@user))
      end
    end

    describe 'PATCH #update' do
      it "redirects to login_path" do
        patch :update, params: {id: create(:element_category).id, element_category: attributes_for(:element_category)}
        expect(response).to redirect_to(user_path(@user))
      end
    end

    describe'DELETE #destroy'do
      it "redirects to login_path" do
        delete :destroy, params: {id: create(:element_category).id}
        expect(response).to redirect_to(user_path(@user))
      end
    end


  end

  describe "No Login Access" do

    describe 'GET #index' do
      it "redirects to login_path" do
        get :index
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it "redirects to login_path" do
        category = create(:element_category)
        get :edit, params: { id: category }
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      it "redirects to login_path" do
        post :create, params: {element_category: attributes_for(:element_category)}
        expect(response).to require_login
      end
    end

    describe 'PATCH #update' do
      it "redirects to login_path" do
        patch :update, params: {id: create(:element_category).id, element_category: attributes_for(:element_category)}
        expect(response).to require_login
      end
    end

    describe'DELETE #destroy'do
      it "redirects to login_path" do
        delete :destroy, params: {id: create(:element_category).id}
        expect(response).to require_login
      end
    end
  end


end
