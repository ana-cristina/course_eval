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

class ProfController < ApplicationController
  before_action :login_required
  before_action :prof_only
  include ProfHelper
  include EvaluationSessionsHelper
  respond_to :html, :js, :pdf

  def index

      @teacher = Teacher.find_by_first_name_and_last_name @current_user.first_name, @current_user.last_name

      ids = EvalSessionActivity.where(teacher_id: @teacher.id).pluck(:evaluation_session_id)
      @evaluation_sessions = EvaluationSession.order(:start_date).where(id: ids, visibility: true).reverse_order

  end


  def view_evaluation
    #(courseId, teacherId, type)

    @course = Course.find_by_id(params[:courseId])
    @teacher = Teacher.find_by_id(params[:teacherId])
    @activityType = params[:type]

    @active_session = EvaluationSession.find_by_id params[:active_session]

    @session_activities = EvalSessionActivity.where(course_id: params[:courseId],
                                                    teacher_id: params[:teacherId],
                                                    activity_type: params[:type],
                                                    evaluation_session_id: params[:active_session])

    @participants_no = CompletedEvaluation.where(eval_session_activity: @session_activities).size


    @completed_for_activity = CompletedEvaluation.where(eval_session_activity: @session_activities).pluck(:content)
    @activity_results = []
    @completed_for_activity.each do |content|
      @activity_results << JSON.parse(content)
    end
    if @activityType == 'Curs'
      form = @active_session.form
    else
      if @activityType == 'Seminar'
        form = @active_session.formS
      else
        if @activityType == 'Laborator'
          form = @active_session.formL
        else
          form = @active_session.formP
        end
      end
    end

    require 'json'
    form_content = JSON.parse form.content
    @content = form_content["chestionar"]
    @departments_select = Department.all
    if request.get?

    else
      respond_to do |format|
        format.js
      end
    end

  end

  def get_comments
    pdf = PdfComments.new(params[:courseId], params[:teacherId], params[:type], params[:active_session])
    course = Course.find_by_id(params[:courseId])
    teacher = Teacher.find_by_id(params[:teacherId])

    send_data pdf.render, filename: "#{teacher.last_name}#{teacher.first_name}#{course.title}-#{params[:type]}.pdf",
              type: 'application/pdf', disposition: 'attachment'
  end


  def download_evaluation
    #(courseId, teacherId, type)

    model = {}
    model['course'] = Course.find_by_id(params[:courseId])
    model['teacher'] = Teacher.find_by_id(params[:teacherId])
    model['activityType'] = params[:type]

    active_session = EvaluationSession.find_by_id params[:active_session]

    model['session_activities'] = EvalSessionActivity.where(course_id: params[:courseId],
                                                            teacher_id: params[:teacherId],
                                                            activity_type: params[:type],
                                                            evaluation_session_id: params[:active_session])

    model['participants_no'] = CompletedEvaluation.where(eval_session_activity: model['session_activities']).size


    model['completed_for_activity'] = CompletedEvaluation.where(eval_session_activity: model['session_activities']).pluck(:content)
    model['activity_results'] = []
    model['completed_for_activity'].each do |content|
      model['activity_results'] << JSON.parse(content)
    end
    if model['activityType'] == 'Curs'
      form = active_session.form
    else
      if model['activityType'] == 'Seminar'
        form = active_session.formS
      else
        if model['activityType'] == 'Laborator'
          form = active_session.formL
        else
          form = active_session.formP
        end
      end
    end

    require 'json'
    form_content = JSON.parse form.content
    model['content'] = form_content["chestionar"]
    model['departments_select'] = Department.all

    votes = []
    nr = 0
    model['content'].each do |section|
      section.each do |parent|
        if parent["intrebare"]
          if parent["intrebare"].first["enunt"]
            r = parent["intrebare"].drop 1
          else
            r = parent["intrebare"]
          end
          votes[nr+1] = get_votes(model['activity_results'], nr+1, r.count)
          nr = nr + 1
        end
      end

    end
    model['votes'] = votes

    respond_to do |format|

      format.pdf do
        render pdf: "#{model['teacher'].last_name}#{model['teacher'].first_name}#{model['course'].title}-#{model['activityType']}-GRILA",
               template: "templates/completed_eval.pdf.erb",
               locals: {:model => model}, disposition: 'attachment'
      end
    end
  end

end
