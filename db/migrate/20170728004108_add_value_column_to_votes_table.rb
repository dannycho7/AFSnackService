class AddValueColumnToVotesTable < ActiveRecord::Migration[5.1]
  def self.up
    add_column :votes, :value, :integer
  end

  def self.down
    remove_column :votes, :value, :integer
  end
end
