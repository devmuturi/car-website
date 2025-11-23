module Admin
  class CarsController < BaseController
    before_action :set_car, only: [ :show, :edit, :update, :destroy, :toggle_status, :remove_image ]

    def index
      @cars = Car.includes(:make, :model, :user).order(created_at: :desc)
      @cars = @cars.where(status: params[:status]) if params[:status].present?
      @cars = @cars.where(condition: params[:condition]) if params[:condition].present?
    end

    def show
    end

    def new
      @car = Car.new
      @makes = Make.order(:name)
      @models = []
    end

    def create
      @car = Car.new(car_params)
      @car.user = current_user

      if @car.save
        redirect_to admin_car_path(@car), notice: "Car was successfully created."
      else
        @makes = Make.order(:name)
        @models = @car.make ? @car.make.models.order(:name) : []
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @makes = Make.order(:name)
      @models = @car.make ? @car.make.models.order(:name) : []
    end

    def update
      if @car.update(car_params)
        redirect_to admin_car_path(@car), notice: "Car was successfully updated."
      else
        @makes = Make.order(:name)
        @models = @car.make ? @car.make.models.order(:name) : []
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @car.destroy
      redirect_to admin_cars_path, notice: "Car was successfully deleted."
    end

    def toggle_status
      @car.update(status: @car.in_stock? ? :sold : :in_stock)
      redirect_to admin_car_path(@car), notice: "Car status updated."
    end

    def remove_image
      @car = Car.find(params[:id])
      image = @car.images.find(params[:image_id])
      image.purge
      redirect_to edit_admin_car_path(@car), notice: "Image removed."
    end

    private

    def set_car
      @car = Car.find(params[:id])
    end

    def car_params
      params.require(:car).permit(
        :make_id, :model_id, :year, :price, :mileage, :condition,
        :body_style, :fuel_type, :transmission, :color, :description,
        :status, :published_at, :specs, images: []
      )
    end
  end
end
