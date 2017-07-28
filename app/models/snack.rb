class Snack < ApplicationRecord
  before_validation { |snack| snack.name = snack.name.downcase }
  has_many :votes

  validates :name, presence: true, uniqueness: true
end
