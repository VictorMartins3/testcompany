class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.text :comment
      t.integer :rating
      t.references :participant, null: false, foreign_key: true
      t.references :talk, null: false, foreign_key: true

      t.timestamps
    end
    add_index :feedbacks, [ :participant_id, :talk_id ], unique: true
  end
end
