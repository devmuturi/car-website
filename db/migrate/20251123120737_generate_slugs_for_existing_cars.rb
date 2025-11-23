class GenerateSlugsForExistingCars < ActiveRecord::Migration[8.0]
  def up
    Car.find_each do |car|
      next if car.slug.present?
      next unless car.make_id.present? && car.model_id.present? && car.year.present?
      
      base_slug = "#{car.make.name}-#{car.model.name}-#{car.year}".parameterize
      slug = base_slug
      counter = 1
      while Car.where.not(id: car.id).exists?(slug: slug)
        slug = "#{base_slug}-#{counter}"
        counter += 1
      end
      car.update_column(:slug, slug)
    end
  end

  def down
    # No need to remove slugs
  end
end
