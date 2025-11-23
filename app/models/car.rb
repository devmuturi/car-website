class Car < ApplicationRecord
  belongs_to :make
  belongs_to :model
  belongs_to :user
  
  has_many_attached :images
  
  enum :status, { in_stock: 0, sold: 1 }
  enum :condition, { brand_new: 0, used: 1 }
  
  validates :year, presence: true, numericality: { greater_than: 1900, less_than_or_equal_to: Date.current.year + 1 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :mileage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :images, presence: true, if: -> { published_at.present? }
  before_validation :generate_slug, on: :create
  before_validation :update_slug, on: :update, if: :should_regenerate_slug?
  
  def to_param
    slug.presence || id.to_s
  end
  
  scope :published, -> { where.not(published_at: nil) }
  scope :by_make, ->(make_id) { where(make_id: make_id) if make_id.present? }
  scope :by_model, ->(model_id) { where(model_id: model_id) if model_id.present? }
  scope :by_year, ->(year) { where(year: year) if year.present? }
  scope :by_condition, ->(condition) { where(condition: condition) if condition.present? }
  scope :by_price_range, ->(min, max) {
    query = all
    query = query.where("price >= ?", min) if min.present?
    query = query.where("price <= ?", max) if max.present?
    query
  }
  
  def published?
    published_at.present?
  end
  
  def main_image
    images.first
  end
  
  def condition_display
    condition == 'brand_new' ? 'New' : condition.humanize
  end
  
  def generate_slug
    return if slug.present? && make_id.present? && model_id.present?
    return unless make_id.present? && model_id.present? && year.present?
    
    base_slug = "#{make.name}-#{model.name}-#{year}".parameterize
    self.slug = base_slug
    counter = 1
    while Car.where.not(id: id || 0).exists?(slug: self.slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
  
  def update_slug
    return unless make_id.present? && model_id.present? && year.present?
    
    base_slug = "#{make.name}-#{model.name}-#{year}".parameterize
    self.slug = base_slug
    counter = 1
    while Car.where.not(id: id).exists?(slug: self.slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
  
  def should_regenerate_slug?
    (make_id_changed? || model_id_changed? || year_changed?) && make_id.present? && model_id.present? && year.present?
  end
  
  # Comparison scoring methods
  def comparison_score
    score = 0.0
    
    # Price score (lower is better) - normalized to 0-100
    max_price = Car.published.maximum(:price) || price
    min_price = Car.published.minimum(:price) || price
    price_range = max_price - min_price
    if price_range > 0
      price_score = ((max_price - price) / price_range) * 100
    else
      price_score = 50
    end
    score += price_score * 0.35
    
    # Year score (newer is better) - normalized to 0-100
    current_year = Date.current.year
    min_year = Car.published.minimum(:year) || year
    year_range = current_year - min_year
    if year_range > 0
      year_score = ((year - min_year) / year_range.to_f) * 100
    else
      year_score = 50
    end
    score += year_score * 0.25
    
    # Mileage score (lower is better) - normalized to 0-100
    max_mileage = Car.published.maximum(:mileage) || mileage
    min_mileage = Car.published.minimum(:mileage) || mileage
    mileage_range = max_mileage - min_mileage
    if mileage_range > 0
      mileage_score = ((max_mileage - mileage) / mileage_range.to_f) * 100
    else
      mileage_score = 50
    end
    score += mileage_score * 0.20
    
    # Condition score (new is better)
    condition_score = condition == 'brand_new' ? 100 : 50
    score += condition_score * 0.10
    
    # Status score (in stock is better)
    status_score = in_stock? ? 100 : 0
    score += status_score * 0.10
    
    score.round(2)
  end
  
  def better_than?(other_car)
    comparison_score > other_car.comparison_score
  end
end
