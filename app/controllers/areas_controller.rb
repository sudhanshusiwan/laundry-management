class AreasController < ApplicationController
  def new
    @area = Area.new
  end

  def create
    area = Area.create(:name => params['area']['name'])
    if area.errors.size > 0
      redirect_to new_area_path, :flash => { :error => "Name: #{area.errors[:name][0].to_s}" } and return
    end
    redirect_to root_path
  end


  private

  def create_params
    params.require(:area).permit(:name)
  end
end
