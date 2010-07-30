class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :problem_id
      t.text :language_id
      t.text :user
      t.text :file
      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
