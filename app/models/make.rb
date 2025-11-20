class Make < ApplicationRecord
  has_many :models, dependent: :destroy
end
