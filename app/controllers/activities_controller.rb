# Copyright (c) 2015 - 2020 Ana-Cristina Turlea <turleaana@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

class ActivitiesController < AdminController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_activityS, only: [ :editS, :updateS, :destroyS]
  skip_before_filter :verify_authenticity_token
  respond_to :html, :js

  def index
    @activities1 = Activity.where(:semester => 1).order(:course_id)
    @activities2 = Activity.where(:semester => 2).order(:course_id)
  end


  def current
    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first

    @activities_terminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session }
    @activities_neterminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_neterminal }
  end


  def edit
  end

  def update
    @activity.update(activity_params)
    @activities1 = Activity.where(:semester => 1).order(:course_id)
    @activities2 = Activity.where(:semester => 2).order(:course_id)
  end

  def new
    @activity = Activity.new
  end

  def create
    activity_params['cohorts'].each do |cohort_id|
      if (!cohort_id.empty?)
        activity_params['activities'].each do |type|
          if (!type.empty?)
            @activity = Activity.new(activity_params)
            @activity.year = if Date.today.month > 8 then
                               Date.today.year
                             else
                               Date.today.year - 1
                             end
            @activity.cohort_id = cohort_id
            @activity.activity_type = type
            @activity.save
          end
        end

      end
    end
    @activities1 = Activity.where(:semester => 1).order(:course_id)
    @activities2 = Activity.where(:semester => 2).order(:course_id)
    respond_to do |format|
      format.js
    end
  end

  def delete
    @activity = Activity.find(params[:activity_id])
  end

  def destroy
    @activity.destroy
    @activities1 = Activity.where(:semester => 1).order(:course_id)
    @activities2 = Activity.where(:semester => 2).order(:course_id)
  end

  def deleteS
    @activityS = EvalSessionActivity.find(params[:activity_id])
  end
  def destroyS
    @activityS.destroy
    current
  end
  def editS
    get_cohorts
  end
  def updateS
    if @activityS.persisted?
        @activityS.update(activityS_params)
        current
    else
      createS
    end
  end
  def newS
    @activityS = EvalSessionActivity.new
    get_cohorts
    print @eval_cohorts

  end

  def createS
    activityS_params['cohorts'].each do |cohort_id|
      if (!cohort_id.empty?)
        activityS_params['activities'].each do |type|
          if (!type.empty?)
            @activityS = EvalSessionActivity.new(activityS_params)
            @activityS.year = if Date.today.month > 8 then
                               Date.today.year
                             else
                               Date.today.year - 1
                              end
            curr_session = EvaluationSessionCohort.find(cohort_id).evaluation_session
            @activityS.semester = curr_session.semester
            @activityS.evaluation_session = curr_session
            @activityS.evaluation_session_cohort_id = cohort_id
            @activityS.activity_type = type
            @activityS.save
          end
        end

      end
    end
   current
    respond_to do |format|
      format.js
    end
  end


  def get_cohorts
    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
    ids = []
    if !@active_session.nil?
      ids << @active_session.id
    end
    if !@active_session_neterminal.nil?
      ids << @active_session_neterminal.id
    end

    print ids
    @eval_cohorts = EvaluationSessionCohort.where(:evaluation_session => ids).collect { |p| [p.name, p.id] }
  end


  def deleteall
    @sem = params[:semester]
  end
  def delete_all_activities_for_exam
    sem = params[:sem]
    activities = Activity.where(:semester => sem, :activity_type => ['Laborator','Seminar','Proiect'])
    activities.delete_all
    @activities1 = Activity.where(:semester => 1).order(:course_id)
    @activities2 = Activity.where(:semester => 2).order(:course_id)
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_activityS
    if params[:activity_id] == '0'
      @activityS = EvalSessionActivity.new
    else
      @activityS = EvalSessionActivity.find(params[:activity_id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_params
    params.require(:activity).permit(:course_id, :cohort_id, :is_optional, :teacher_id, :semester, :activity_type, :year, :cohorts => [], :activities => [])
  end
  def activityS_params
    params.require(:eval_session_activity).permit(:course_id, :evaluation_session_cohort_id, :is_optional, :teacher_id, :semester, :activity_type, :year, :cohorts => [], :activities => [])
  end
end
