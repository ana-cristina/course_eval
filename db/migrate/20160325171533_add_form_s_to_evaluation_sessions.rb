class AddFormSToEvaluationSessions < ActiveRecord::Migration
  def change
    add_column :evaluation_sessions, :formS_id, :integer , :references => :forms
    add_column :evaluation_sessions, :formL_id, :integer, :references => :forms

  end
end
