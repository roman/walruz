class CreateColaborations < ActiveRecord::Migration
  def self.up
    create_table :colaborations do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :beatles_colaborations do |t|
      t.integer :beatle_id
      t.integer :colaboration_id
    end
  end

  def self.down
    drop_table :colaborations
  end
end
