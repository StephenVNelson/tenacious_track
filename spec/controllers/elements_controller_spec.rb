require 'rails_helper'

RSpec.describe ElementsController, type: :controller do

  # TODO: 1 figure out site access for element_category
  # Role     Index   Create   Update   Destroy
  # Admin    Full    Full     Full     Full
  # Trainer  Full    None     None     None
  # NoLogin  None    None     None     None

  shared_examples 'Trainer access' do
    describe 'GET #index' do

    end

  end

end
