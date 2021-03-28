class RemoveCohortFromIncognitoUsers < ActiveRecord::Migration[4.2]
  def change
    remove_reference :incognito_users, :cohort, index: true, foreign_key: true
    add_reference :incognito_users, :evaluation_session_cohort, index: true, foreign_key: true
  end
end
