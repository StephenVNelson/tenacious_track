require 'rails_helper'

RSpec.describe ElementsController, type: :controller do

  # TODO: 1 figure out site access for element_category
  # Role     Index   Create   Update   Destroy
  # Admin    Full    Full     Full     Full
  # Trainer  Full    None     None     None
  # NoLogin  None    None     None     None

  describe 'trainer access' do
    before(:example) do
      set_user_session(create(:user))
    end
    shared_examples 'general access' do

      describe 'GET #index' do

        it 'populates an array of :all_elements' do
          element1 = create(:element, name: "El_1")
          element2 = create(:element, name: "El_2")
          expect(assigns(:all_elements)).not_to match_array([element1, element2])
        end

        it "renders the :index template" do
          get :index
          expect(response).to render_template(:index)
        end

      end

    end
  end

end
