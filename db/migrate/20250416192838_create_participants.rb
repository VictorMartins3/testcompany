class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
