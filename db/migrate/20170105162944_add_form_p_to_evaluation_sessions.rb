class AddFormPToEvaluationSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :evaluation_sessions, :formP_id, :integer, :references => :forms
  end
end
