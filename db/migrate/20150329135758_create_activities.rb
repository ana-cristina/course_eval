class CreateActivities < ActiveRecord::Migration[4.2]
  def change
    create_table :activities do |t|
      t.references :course, index: true, foreign_key: true
      t.references :cohort, index: true, foreign_key: true
      t.boolean :is_optional

      t.timestamps null: false
    end
  end
end
