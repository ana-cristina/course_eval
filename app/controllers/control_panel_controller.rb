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

class ControlPanelController < AdminController
  skip_before_action :verify_authenticity_token
  include ControlPanelHelper
  respond_to :html, :js

  def index
    #@courses_semI = getCoursesForSemester(1)
    #@courses_semII = getCoursesForSemester(2);
    @current_tab = 'setari'
    @departments_select = Department.all
    @selected_department = 0
    @tab = params['tab']
    if @tab.nil?
      @tab = 'activities'
    end
    if @tab == 'cohorts'
      @cohorts = Cohort.all
    elsif @tab == 'teachers'
      @teachers = Teacher.order(:last_name)
    elsif @tab == 'departments'
      @departments = Department.all
    elsif @tab == 'courses'
      @courses = Course.order(:title)
    elsif @tab == 'activities'
      @activities1 = Activity.where(:semester => 1).order(:course_id)
      @activities2 = Activity.where(:semester => 2).order(:course_id)
    elsif @tab == 'current'
      @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
      @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first

      @activities_terminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session }
      @activities_neterminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_neterminal }
    end
  end
end
