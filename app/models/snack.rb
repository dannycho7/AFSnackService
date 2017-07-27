class Snack < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  attr_accessor :store
end
