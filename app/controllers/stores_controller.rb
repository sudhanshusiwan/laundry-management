class StoresController < ApplicationController
  def index

  end

  def new
    @store = Store.new
  end

  def create
    store = Store.create(:name => params['store']['name'],:owner_id => current_user.id , :area_id => params['store']['area_id'], :operations => params['store']['operations'])
    if store.errors.size > 0
      flash[:error] = store.errors.empty? ? "Error" : store.errors.full_messages.to_sentence
      redirect_to new_store_path and return
    end
    redirect_to root_path
  end

  def edit
    @store = current_user.store
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(update_params)
      redirect_to root_path :flash => {:success => "Store updated successfully!!"} and return
    else
      # flash[:error] = store.errors.empty? ? "Error" : @store.errors.full_messages.to_sentence
      redirect_to edit_store_path(@store), :flash => {:error => "Error in updating, please try again!"}
    end
  end

  private

  def create_params
    params.require(:store).permit(:name, :area_id, :operations)
  end

  def update_params
    params.require(:store).permit(:name, :area_id, :operations)
  end
end
