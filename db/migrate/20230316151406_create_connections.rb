class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.integer :follower_id
      t.integer :following_id

      t.timestamps
    end

    add_index :connections, :follower_id
    add_index :connections, :following_id
    add_index :connections, [:follower_id, :following_id], unique: true
  end
end
