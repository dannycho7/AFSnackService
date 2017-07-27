class Snack < ApplicationRecord
  has_many :votes
  validates :name, presence: true, uniqueness: true
  attr_accessor :store
end
