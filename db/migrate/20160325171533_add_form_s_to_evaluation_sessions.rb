class AddFormSToEvaluationSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :evaluation_sessions, :formS_id, :integer , :references => :forms
    add_column :evaluation_sessions, :formL_id, :integer, :references => :forms

  end
end
