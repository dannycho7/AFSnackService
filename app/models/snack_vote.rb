class SnackVote < ApplicationRecord
  belongs_to :snack
  validates :votes, presence: true
end
