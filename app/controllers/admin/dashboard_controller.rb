module Admin
  class DashboardController < BaseController
    def index
      @total_cars = Car.count
      @in_stock_cars = Car.in_stock.count
      @sold_cars = Car.sold.count
      @published_cars = Car.published.count
      @recent_cars = Car.includes(:make, :model).order(created_at: :desc).limit(5)
    end
  end
end

