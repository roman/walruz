class CreateBeatles < ActiveRecord::Migration
  def self.up
    create_table :beatles do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :beatles
  end
end
