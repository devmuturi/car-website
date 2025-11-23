module Admin
  class ModelsController < BaseController
    before_action :set_model, only: [:show, :edit, :update, :destroy]
    
    def index
      @models = Model.includes(:make).order("makes.name", :name)
    end
    
    def show
    end
    
    def new
      @model = Model.new
      @makes = Make.order(:name)
    end
    
    def create
      @model = Model.new(model_params)
      if @model.save
        redirect_to admin_models_path, notice: "Model was successfully created."
      else
        @makes = Make.order(:name)
        render :new, status: :unprocessable_entity
      end
    end
    
    def edit
      @makes = Make.order(:name)
    end
    
    def update
      if @model.update(model_params)
        redirect_to admin_models_path, notice: "Model was successfully updated."
      else
        @makes = Make.order(:name)
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
      @model.destroy
      redirect_to admin_models_path, notice: "Model was successfully deleted."
    end
    
    def models_json
      if params[:make_id].present?
        make = Make.find_by(id: params[:make_id])
        if make
          models = make.models.order(:name)
          render json: models.map { |m| { id: m.id, name: m.name } }
        else
          render json: []
        end
      else
        render json: []
      end
    end
    
    private
    
    def set_model
      @model = Model.find(params[:id])
    end
    
    def model_params
      params.require(:model).permit(:make_id, :name, :generation)
    end
  end
end
