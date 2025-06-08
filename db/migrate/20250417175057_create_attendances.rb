class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :talk, null: false, foreign_key: true

      t.timestamps
    end

    add_index :attendances, [ :participant_id, :talk_id ], unique: true
  end
end
