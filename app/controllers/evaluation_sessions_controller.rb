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

class EvaluationSessionsController < AdminController
  before_action :set_evaluation_session, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  include EvaluationSessionsHelper
  respond_to :html, :js, :pdf

  def current_session
    @current_tab = 'sesiune activa'

    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first

    @activities_terminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }
    @activities_neterminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_neterminal }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }

    updateData

    getStats

  end

  def activities_neterminal_list
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first

    if params['department'] != ''
      courses = Course.where(department_id: params['department'])
      @activities_neterminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_neterminal and courses.include?(activity.course) == true }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }
    else
      @activities_neterminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_neterminal }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }
    end
    respond_to do |format|
      format.js
    end
  end

  def activities_terminal_list
    @active_session_terminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first

    if params['department'] != ''
      courses = Course.where(department_id: params['department'])
      @activities_terminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_terminal and courses.include?(activity.course) == true }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }
    else
      @activities_terminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_terminal }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }
    end
    respond_to do |format|
      format.js
    end
  end

  def index
    @current_tab = 'arhiva sesiuni'
    @evaluation_sessions = getAllEvaluationSessions(true)
    @evaluation_sessions_neterminal = getAllEvaluationSessions(false)
    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
  end


  def show
  end


  def new
    @evaluation_session = EvaluationSession.new

  end

  def new1
    @evaluation_session = EvaluationSession.new

  end


  def edit
    @evaluation_session = EvaluationSession.find(params[:id])


  end


  def create

    validate_request(0)

    if @evaluation_session.errors.any?

    else
      ActiveRecord::Base.transaction do
        if @chestionar
          @form = Form.create content: @chestionar, title: @chestionar_title
          @evaluation_session.form_id = @form.id
        end
        if @chestionar_L
          form = Form.create content: @chestionar_L, title: @chestionar_L_title
          @evaluation_session.formL_id = form.id
        end
        if @chestionar_S
          form = Form.create content: @chestionar_S, title: @chestionar_S_title
          @evaluation_session.formS_id = form.id
        end
        if @chestionar_P

          form = Form.create content: @chestionar_P, title: @chestionar_P_title
          @evaluation_session.formP_id = form.id
        end
        @evaluation_session.save

      end
    end
    @evaluation_sessions = getAllEvaluationSessions(true)
    @evaluation_sessions_neterminal = getAllEvaluationSessions(false)
    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
    respond_to do |format|
      format.js
    end
  end


  def update

    @evaluation_session = EvaluationSession.find(params[:id])
    validate_request(params[:id])


    if @evaluation_session.errors.any?

    else
      ActiveRecord::Base.transaction do
        if @chestionar
          @form = Form.create content: @chestionar, title: @chestionar_title
          @evaluation_session.form_id = @form.id
        end
        if @chestionar_L
          form = Form.create content: @chestionar_L, title: @chestionar_L_title
          @evaluation_session.formL_id = form.id
        end
        if @chestionar_S
          form = Form.create content: @chestionar_S, title: @chestionar_S_title
          @evaluation_session.formS_id = form.id
        end
        if @chestionar_P
          form = Form.create content: @chestionar_P, title: @chestionar_P_title
          @evaluation_session.formP_id = form.id
        end
        @evaluation_session.save

      end
    end
    @evaluation_sessions = getAllEvaluationSessions(true)
    @evaluation_sessions_neterminal = getAllEvaluationSessions(false)
    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
    respond_to do |format|
      format.js
    end
  end

  def delete
    @evaluation_session = EvaluationSession.find(params[:evaluation_session_id])
  end

  def destroy

    #TODO delete forms after delete a session
    @evaluation_session = EvaluationSession.find(params[:id])
    delete_all_tokens(@evaluation_session)

    #EvalSessionActivity.where(evaluation_session_id: @evaluation_session).delete_all
    #EvaluationSessionCohort.where(evaluation_session_id: @evaluation_session).delete_all


    @evaluation_session.destroy
    @evaluation_sessions = getAllEvaluationSessions(true)
    @evaluation_sessions_neterminal = getAllEvaluationSessions(false)
    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
  end


  def edit_session
    respond_to do |format|
      format.html
      format.js
    end
  end

  def activate

    @evaluation_session = EvaluationSession.find(params[:evaluation_session_id])
    if request.post?
      @evaluation_session.status = 'Activa'
      @evaluation_session.save
      add_evaluation_session_activities(@evaluation_session)
      @evaluation_sessions = getAllEvaluationSessions(true)
      @evaluation_sessions_neterminal = getAllEvaluationSessions(false)
      @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
      @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
    end
  end

  def finalize

    @evaluation_session = EvaluationSession.find(params[:evaluation_session_id])
    if request.post?
      @evaluation_session.status = 'Finalizata'
      @evaluation_session.save
      @evaluation_sessions = getAllEvaluationSessions(true)
      @evaluation_sessions_neterminal = getAllEvaluationSessions(false)
      @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
      @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
      delete_all_tokens(@evaluation_session)
    end
  end


  def generate

    if request.post?
      @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
      @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first

      @activities_terminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }


      @activities_neterminal = EvalSessionActivity.order(:course_id).select { |activity| activity.evaluation_session == @active_session_neterminal }.group_by { |s| [s.course_id, s.teacher_id, s.activity_type] }


      if !@active_session.nil? and @active_session.id == params[:evaluation_session_id].to_i
        generate_tokens(@active_session)
      end

      if !@active_session_neterminal.nil? and @active_session_neterminal.id == params[:evaluation_session_id].to_i
        generate_tokens(@active_session_neterminal)
      end
    end
    updateData
  end


  def get_tokens
    session = EvaluationSession.find_by_id params[:evaluation_session_id]

    pdf = TokensPdf.new(session)
    send_data pdf.render, filename: "Grupe_#{session.terminal==true ? 'terminal' : 'neterminal'}e.pdf", type: 'application/pdf', disposition: 'attachment'

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


  def descarca
    @teacher = Teacher.find 45

=begin
    respond_to do |format|
     # format.html
      format.pdf do
        render pdf: "test",
               template: "templates/show.pdf.erb",
               locals: {:teacher => @teacher}
      end
    end
=end

    test_pdf = render_to_string pdf: "test",
                                template: "templates/show.pdf.erb",
                                locals: {:teacher => @teacher}
    send_data(test_pdf, :filename => "test.pdf",
              :type => 'application/pdf')
  end


  def set_visibility
    evaluation_session = EvaluationSession.find(params[:evaluation_id])
    evaluation_session.visibility = !evaluation_session.visibility
    evaluation_session.save

    @evaluation_sessions = getAllEvaluationSessions(true)
    @evaluation_sessions_neterminal = getAllEvaluationSessions(false)
    @active_session = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == true }.first
    @active_session_neterminal = EvaluationSession.all.select { |session| session.session_status == 'Activa' and session.terminal == false }.first
  end

  private
  # Use callbacks to share common setup or constraints beteween actions.
  def set_evaluation_session
    @evaluation_session = EvaluationSession.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def evaluation_session_params
    params.require(:evaluation_session).permit(:semester, :start_date, :end_date, :terminal, :start_date_terminal, :end_date_terminal, :from_upload, :form1, :form2, :from_uploadL, :formL1, :formL2, :from_uploadP, :formP1, :formP2, :from_uploadS, :formS1, :formS2)
  end


end
