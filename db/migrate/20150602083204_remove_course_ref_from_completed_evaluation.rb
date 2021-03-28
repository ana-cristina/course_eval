class RemoveCourseRefFromCompletedEvaluation < ActiveRecord::Migration[4.2]
  def change
    remove_reference :completed_evaluations, :course, index: true, foreign_key: true
    add_reference :completed_evaluations, :eval_session_activity, index: true, foreign_key: true
  end
end
