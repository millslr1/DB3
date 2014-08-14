class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :follower_id, index: true
      t.integer :followed_id, index: true
    end
  end
end 
