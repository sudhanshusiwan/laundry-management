class ClothsController < ApplicationController
  def index
    @order = Order.find(params[:order_id])
    @cloths = @order.cloths
    authorize @cloths
  end

  def new
    @cloth = Cloth.new
    authorize @cloth
  end

  def create
    cloth = Cloth.create(:cloth_type_id => params['cloth']['cloth_type'], :wash_type => params['cloth']['wash_type'],
                          :count => params['cloth']['count'], :order_id => params['order_id'])
    if cloth.errors.size > 0
      flash[:error] = cloth.errors.empty? ? "Error" : cloth.errors.full_messages.to_sentence
      redirect_to new_order_cloth_path(params['order_id']) and return
    end
    authorize cloth
    Order.mark_picked(params[:order_id])
    redirect_to order_cloths_path(:order_id => params[:order_id])
  end

  def edit
    @cloth = Cloth.find(params['id'].to_i)
    authorize @cloth
  end

  def update
    @cloth = Cloth.find(params['id'])
    authorize @cloth

    if @cloth.update_attributes(update_params)
      redirect_to order_cloths_path(:order_id => @cloth.order_id), :flash => {:success => "Cloth updated successfully!!"} and return
    else
      # flash[:error] = store.errors.empty? ? "Error" : @store.errors.full_messages.to_sentence
      redirect_to edit_order_cloth_path(params['order_id'], @cloth), :flash => {:error => "Error in updating, please try again!"}
    end
  end

  def destroy
    @order = Order.find(params[:order_id])
    @cloth = Cloth.find(params[:id])
    authorize @cloth
    @cloth.destroy
    redirect_to order_cloths_path(:order_id => @order.id)
  end

  private

  def update_params
    params.require(:cloth).permit(:cloth_type_id, :wash_type, :count)
  end
end
