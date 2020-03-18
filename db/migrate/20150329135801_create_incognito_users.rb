class CreateIncognitoUsers < ActiveRecord::Migration
  def change
    create_table :incognito_users do |t|
      t.string :token
      t.references :cohort, index: true, foreign_key: true
      t.references :evaluation_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
