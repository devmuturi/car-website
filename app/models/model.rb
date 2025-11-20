class Model < ApplicationRecord
  belongs_to :make
  has_many :cars, dependent: :destroy
end
