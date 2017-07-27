class Vote < ApplicationRecord
  validate :check_duplicate

  belongs_to :user
  belongs_to :snack

  private
  def check_duplicate
    puts "User id: #{user_id}, Snack id: #{snack_id}"
    if Vote.find_by(user_id: user_id, snack_id: snack_id)
      errors.add(:user, 'Duplicate vote')
    end
  end
end
