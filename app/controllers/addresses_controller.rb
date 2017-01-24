class AddressesController < ApplicationController
  def index
    @user = User.find(params['user_id'])
    @addresses = @user.addresses
    authorize @addresses
  end

  def new
    @address = Address.new
  end

  def create
    address = Address.create(:owner_id => current_user.id, :line1 => params['address']['line1'], :line2 => params['address']['line2'],
                             :area_id => params['address']['area_id'], :city => params['address']['city'], :pin => params['address']['pin'])
    if address.errors.size > 0
      flash[:error] = address.errors.empty? ? "Error" : address.errors.full_messages.to_sentence
      redirect_to new_user_address_path and return
    end
    redirect_to user_addresses_path(current_user)
  end

  def edit
    @address = Address.where(:owner_id => current_user.id, :id => params['id']).first
    if @address.nil?
      redirect_to root_path, :flash => {:error => "Address could not be found!!"}
    end
  end

  def update
    @address = Address.where(:owner_id => current_user.id, :id => params['id']).first
    if @address.nil?
      redirect_to root_path, :flash => {:error => "Address could not be found!!"}
    end

    if @address.update_attributes(update_params)
      redirect_to root_path :flash => {:success => "Address updated successfully!!"} and return
    else
      # flash[:error] = store.errors.empty? ? "Error" : @store.errors.full_messages.to_sentence
      redirect_to edit_user_address_path(current_user, @address), :flash => {:error => "Error in updating, please try again!"}
    end
  end

  private

  def update_params
    params.require(:address).permit(:line1, :line2, :area_id, :city, :pin)
  end
end
