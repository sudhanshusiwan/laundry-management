require 'rails_helper'

describe StoresController do
  before :each do
    @user = User.first
    sign_in @user
  end

  describe "GET new" do
    it "renders new template" do
      get :new

      expect(response).to render_template(:new)
    end

    it "does not render index template" do
      get :new

      expect(response).not_to render_template(:index)
    end
  end

  describe "GET index" do
    it "renders index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "does not render new template" do
      get :index

      expect(response).not_to render_template(:new)
    end
  end
end