class CreateActiveIncognitoUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :active_incognito_users do |t|
      t.datetime :start_date
      t.string :incognito_user_token

      t.timestamps null: false
    end
  end
end
