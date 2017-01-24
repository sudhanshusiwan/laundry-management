class OrdersController < ApplicationController
  def index
    if current_user.customer?
      @orders = current_user.my_orders
    elsif current_user.admin?
      @orders = current_user.my_orders
    elsif current_user.pickup_boy?
      @pick_orders = current_user.pick_orders
      @drop_orders = current_user.drop_orders
      @my_pick_orders = current_user.my_pick_orders + current_user.to_store_orders
      @my_drop_orders = current_user.my_drop_orders
    elsif current_user.store_owner?
      @orders = current_user.my_orders
    end
  end

  def new
    @order = Order.new
    #creator can be admin or normal user
    authorize @order
    if params['address_id'].nil?
      redirect_to user_addresses_path(current_user), :flash => {:error => "First choose the address for ordering."} and return
    else
      @order.address_id = params['address_id']
    end
    @nearby_laundry_stores = @order.nearby_laundry_stores(params['address_id'])
    @nearby_dryclean_stores = @order.nearby_dryclean_stores(params['address_id'])
  end

  def create
    order = Order.create(:customer_id => current_user.id, :order_time => Time.now, :to_pick_date => params['order']['to_pick_date'],
                         :to_pick_time => params['order']['to_pick_time'], :laundry_store_id => params['order']['laundry_store_id'],
                         :dryclean_store_id => params['order']['dryclean_store_id'], :address_id => params['order']['address_id'],
                         :status => 'ordered')

    #creator can be admin or normal user
    authorize order
    if order.errors.size > 0
      flash[:error] = order.errors.empty? ? "Error" : order.errors.full_messages.to_sentence
      redirect_to new_order_path(:address_id => params['order']['address_id']) and return
    end
    redirect_to root_path
  end

  def edit
    @order = Order.find(params[:id])
    authorize @order
    @nearby_laundry_stores = @order.nearby_laundry_stores(@order.address_id)
    @nearby_dryclean_stores = @order.nearby_dryclean_stores(@order.address_id)
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    if @order.update_attributes(update_params)
      redirect_to root_path :flash => {:success => "Order updated successfully!!"} and return
    else
      redirect_to edit_order_path(@order), :flash => {:error => "Error in updating, please try again!"}
    end
  end

  def cancel
    @order = Order.find(params[:id])
    #cancelled by current_user(customer/admin) only
    authorize @order
    if !@order.cancellable?
      redirect_to root_path, :flash => {:error => "Order is not cancellable!"} and return
    end
    @order.cancel_order
    redirect_to root_path
  end

  def pick
    @order = Order.find(params[:id])
    #user(pickup_boy/admin) with pickable order
    authorize @order
    @order.set_picker(current_user.id)
    redirect_to root_path
  end

  def in_store
    @order = Order.find(params[:id])
    #user(pickup_boy/admin) with picked order
    authorize @order
    @order.mark_instore
    redirect_to root_path
  end

  def wont_pick
    @order = Order.find(params[:id])
    #user(pickup_boy/admin) with pickable order
    authorize @order
    @order.remove_picker
    redirect_to root_path
  end

  def drop
    @order = Order.find(params[:id])
    #user(pickup_boy/admin) with droppable order
    authorize @order
    @order.set_dropper(current_user.id)
    redirect_to root_path
  end

  def wont_drop
    @order = Order.find(params[:id])
    #user(pickup_boy/admin) with droppable order
    authorize @order
    @order.remove_dropper
    redirect_to root_path
  end

  def dropped
    @order = Order.find(params[:id])
    #user(pickup_boy/admin) with droppable order
    authorize @order
    @order.mark_dropped
    redirect_to root_path
  end

  def washed
    @order = Order.find(params[:id])
    #user(store_owner/admin) with droppable order
    authorize @order
    @order.mark_washed
    redirect_to root_path
  end

  private

  def update_params
    params.require(:order).permit(:laundry_store_id, :dryclean_store_id, :to_pick_date, :to_pick_time)
  end
end
