require 'rails_helper'

RSpec.describe 'TradesControllers', type: :request do
  context 'index' do
    it 'must render the correct template' do
      get '/trades'
      expect(response).to render_template(:index)
    end
    it 'must not render the wrong correct template' do
      get '/trades'
      expect(response).to_not render_template(:new)
    end
  end
  context 'new' do
    it 'must render the correct template' do
      get '/trades/new'
      expect(response).to render_template(:new)
    end
    it 'must not render the wrong correct template' do
      get '/trades/new'
      expect(response).to_not render_template(:index)
    end
  end
end
