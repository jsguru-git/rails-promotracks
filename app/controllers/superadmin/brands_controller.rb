class Superadmin::BrandsController < Superadmin::SuperadminApplicationController


  def index
    @brands=Brand.active_brands
  end


  def new
    @brand=Brand.new
  end

  def create
    @brand=Brand.new(brand_params)
    if @brand.valid?
      @brand.save
      flash[:notice]= "Brand created Successfully"
      redirect_to superadmin_brands_path
    else
      flash[:error]=@brand.errors.full_messages.join(', ')
      render :new
    end
  end


  def edit
    @brand=Brand.find(params[:id])
  end

  def update
    @brand=Brand.find(params[:id])
    if @brand.update_attributes(brand_params)
      redirect_to superadmin_brands_path
    else
      flash[:error]=@brand.errors.full_messages.join(', ')
      render :edit
    end
  end


  def destroy
    @brand=Brand.find(params[:id])
    @brand.update_attribute(:deleted, true)
    redirect_to superadmin_brands_path
  end

  private
  def brand_params
    params.require(:brand).permit(:name, :description)
  end

end