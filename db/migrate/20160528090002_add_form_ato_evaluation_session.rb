class AddFormAtoEvaluationSession < ActiveRecord::Migration[4.2]
  def change
    add_column :evaluation_sessions, :formA_id, :integer , :references => :forms
  end
end
