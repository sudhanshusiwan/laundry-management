class ClothTypesController < ApplicationController
  def index
    @cloth_types = ClothType.all
  end

  def new
    @cloth_type = ClothType.new
    authorize @cloth_type
  end

  def create
    cloth_type = ClothType.create(:name => params['cloth_type']['name'], :laundry_price => params['cloth_type']['laundry_price'],
                             :dryclean_price => params['cloth_type']['dryclean_price'])
    if cloth_type.errors.size > 0
      flash[:error] = cloth_type.errors.empty? ? "Error" : cloth_type.errors.full_messages.to_sentence
      redirect_to new_cloth_type_path and return
    end
    authorize cloth_type
    redirect_to root_path
  end

  def edit
    @cloth_type = ClothType.find(params['id'].to_i)
    authorize @cloth_type
  end

  def update
    @cloth_type = ClothType.find(params['id'])
    authorize @cloth_type
    if @cloth_type.update_attributes(update_params)
      redirect_to root_path :flash => {:success => 'Cloth Type updated successfully!!'} and return
    else
      redirect_to edit_cloth_type_path(@cloth_type), :flash => {:error => 'Error in updating, please try again!'}
    end
  end

  def destroy
    @cloth_type = ClothType.find(params[:id])
    authorize @cloth_type
    if !@cloth_type.destroy
      flash[:error] = @cloth_type.errors.empty? ? 'Error: Cloth Type was not removed. Some dependent records are there.' : cloth_type.errors.full_messages.to_sentence
      redirect_to cloth_types_path and return
    end
    redirect_to cloth_types_path, :flash => {:error => 'Cloth Type has been removed!'}
  end

  private

  def update_params
    params.require(:cloth_type).permit(:name, :laundry_price, :dryclean_price)
  end
end
