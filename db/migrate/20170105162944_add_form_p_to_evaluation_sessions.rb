class AddFormPToEvaluationSessions < ActiveRecord::Migration
  def change
    add_column :evaluation_sessions, :formP_id, :integer, :references => :forms
  end
end
