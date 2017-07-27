class CreateSnackVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :snack_votes do |t|
      t.belongs_to :snack, index: true
      t.string :period
      t.integer :votes

      t.timestamps
    end
  end
end
