class CreateCompletedEvaluations < ActiveRecord::Migration
  def change
    create_table :completed_evaluations do |t|
      t.references :course, index: true, foreign_key: true
      t.string :incognito_token
      t.text :content
      t.integer :time
      t.datetime :date

      t.timestamps null: false
    end
  end
end
