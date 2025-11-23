module V1
  class CarsController < BaseController
    before_action :set_car, only: [ :show ]

    def index
      @cars = Car.published.includes(:make, :model, images_attachments: :blob)

      # Filters
      @cars = @cars.by_make(params[:make_id]) if params[:make_id].present?
      @cars = @cars.by_model(params[:model_id]) if params[:model_id].present?
      @cars = @cars.by_year(params[:year]) if params[:year].present?
      @cars = @cars.by_condition(params[:condition]) if params[:condition].present?
      @cars = @cars.by_price_range(params[:min_price], params[:max_price])
      @cars = @cars.in_stock if params[:in_stock] == "true"

      # Sorting
      case params[:sort]
      when "price_asc"
        @cars = @cars.order(price: :asc)
      when "price_desc"
        @cars = @cars.order(price: :desc)
      when "year_desc"
        @cars = @cars.order(year: :desc)
      when "year_asc"
        @cars = @cars.order(year: :asc)
      else
        @cars = @cars.order(created_at: :desc)
      end

      @makes = Make.order(:name)
      @models = Model.order(:name)
      @years = Car.published.distinct.pluck(:year).sort.reverse

      @cars = @cars.page(params[:page] || 1).per(12)
    end

    def show
      @related_cars = Car.published
                         .where(make_id: @car.make_id)
                         .where.not(id: @car.id)
                         .limit(4)
                         .includes(:make, :model, images_attachments: :blob)

      # Generate slug if missing
      @car.generate_slug && @car.save if @car.slug.blank?
    end

    def compare
        if params[:car1].present?
          @car1 = find_car_by_slug_or_id(params[:car1])
          @car2 = find_car_by_slug_or_id(params[:car2]) if params[:car2].present?

          if @car2
            @winner = @car1.better_than?(@car2) ? @car1 : @car2
            @car1_score = @car1.comparison_score
            @car2_score = @car2.comparison_score
          end
        else
          redirect_to v1_cars_path, alert: "Please select cars to compare."
        end
      rescue ActiveRecord::RecordNotFound
        redirect_to v1_cars_path, alert: "One or both cars could not be found."
      end


    private

    def set_car
      @car = find_car_by_slug_or_id(params[:slug])
    end

    def find_car_by_slug_or_id(identifier)
        # Check if identifier is numeric (id) or string (slug)
        if identifier.to_s =~ /\A\d+\z/
          Car.find(identifier)  # find by ID
        else
          Car.find_by!(slug: identifier)  # find by slug
        end
      end
  end
end
