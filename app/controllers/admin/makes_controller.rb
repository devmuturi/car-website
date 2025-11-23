module Admin
  class MakesController < BaseController
    before_action :set_make, only: [:show, :edit, :update, :destroy]
    
    def index
      @makes = Make.order(:name)
    end
    
    def show
    end
    
    def new
      @make = Make.new
    end
    
    def create
      @make = Make.new(make_params)
      if @make.save
        redirect_to admin_makes_path, notice: "Make was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    def edit
    end
    
    def update
      if @make.update(make_params)
        redirect_to admin_makes_path, notice: "Make was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
      @make.destroy
      redirect_to admin_makes_path, notice: "Make was successfully deleted."
    end
    
    def models
        make = Make.find(params[:id])
        models = make.models.select(:id, :name).order(:name)
        render json: models
    end
    
    private
    
    def set_make
      @make = Make.find(params[:id])
    end
    
    def make_params
      params.require(:make).permit(:name, :country)
    end
  end
end

