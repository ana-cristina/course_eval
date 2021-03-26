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

module StatisticsHelper
  include EvaluationSessionsHelper

  def get_activities_for_session_and_course(session_id, course_id)

    return EvalSessionActivity.select { |activity| activity.evaluation_session_id == session_id and activity.course_id == course_id }.group_by { |s| [s.teacher_id, s.activity_type] }
  end

  def get_activities_for_session_and_teacher(session_id, teacher_id)

    return EvalSessionActivity.select { |activity| activity.evaluation_session_id == session_id and activity.teacher_id == teacher_id }.group_by { |s| [s.course_id, s.activity_type] }

  end
  
  def generate_evaluation_questions(course, teacher, type, active_session, ev)
    model = {}
    model['course'] = course
    model['teacher'] = teacher
    model['activityType'] = type
    model['session_activities'] = ev

    model['participants_no'] = CompletedEvaluation.where(eval_session_activity: model['session_activities']).size

    model['completed_for_activity'] = CompletedEvaluation.where(eval_session_activity: model['session_activities']).pluck(:content)
    model['activity_results'] = []
    model['completed_for_activity'].each do |content|
      model['activity_results'] << JSON.parse(content)
    end
    form = if model['activityType'] == 'Curs'
      active_session.form
    else
      if model['activityType'] == 'Seminar'
        active_session.formS
      else
        if model['activityType'] == 'Laborator'
          active_session.formL
        else
          active_session.formP
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
          r = if parent["intrebare"].first["enunt"]
            parent["intrebare"].drop 1
          else
            parent["intrebare"]
              end
          votes[nr+1] = get_votes(model['activity_results'], nr+1, r.count)
          nr = nr + 1
        end
      end

    end
    model['votes'] = votes

    @mod = model

    pdf = PDFKit.new(
        (render_to_string template: 'templates/completed_eval.pdf.erb',
                          layout: false))
    pdf


  end
end
