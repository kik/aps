class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.text :title
      t.text :description
      t.text :options
      t.text :verifier
      t.text :assumption
      t.timestamps
    end
  end

  def self.down
    drop_table :problems
  end
end
