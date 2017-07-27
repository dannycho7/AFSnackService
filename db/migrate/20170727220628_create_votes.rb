class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :snack
      t.belongs_to :user
    end
  end
end
