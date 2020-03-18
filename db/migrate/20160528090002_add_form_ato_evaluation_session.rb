class AddFormAtoEvaluationSession < ActiveRecord::Migration
  def change
    add_column :evaluation_sessions, :formA_id, :integer , :references => :forms
  end
end
