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

module EvaluationSessionsHelper
  include AdminHelper

  def getStats
    if @active_session.nil?
      id11 = EvaluationSession.where(status: 'Finalizata', terminal: true)
      if id11.last.nil?
        id1 = 0
      else
        id1 = id11.last.id
      end
    else
      id1 = @active_session.id
    end
    if @active_session_neterminal.nil?
      id22 = EvaluationSession.where(status: 'Finalizata', terminal: false)
      if id22.last.nil?
        id2 = 0
      else
        id2 = id22.last.id
      end
    else
      id2 = @active_session_neterminal.id
    end
    query = "SELECT count( distinct incognito_token), evaluation_session_cohorts.name
      FROM
        public.completed_evaluations,
        public.eval_session_activities,
        public.evaluation_sessions,
        public.evaluation_session_cohorts
      WHERE
        completed_evaluations.eval_session_activity_id = eval_session_activities.id AND
        eval_session_activities.evaluation_session_id = evaluation_sessions.id AND
        evaluation_session_cohorts.id = eval_session_activities.evaluation_session_cohort_id AND
        (evaluation_sessions.id = #{id1} or evaluation_sessions.id = #{id2} )
      group by evaluation_session_cohorts.name;"

    @results = ActiveRecord::Base.connection.execute(query).values

  end

  def updateData
    @terminal_tokens = IncognitoUser.where(evaluation_session: @active_session)

    @neterminal_tokens = IncognitoUser.where(evaluation_session: @active_session_neterminal)

    @departments_select = Department.all
    if @active_session.nil?
      @nrOfStudents = 0
    else
      @nrOfStudents = CompletedEvaluation.joins(:eval_session_activity).where(eval_session_activities: {evaluation_session_id: @active_session.id}).distinct.count(:incognito_token)
    end

    if @active_session_neterminal.nil?
      @nrOfStudentsNeterminal = 0
    else
      @nrOfStudentsNeterminal = CompletedEvaluation.joins(:eval_session_activity).where(eval_session_activities: {evaluation_session_id: @active_session_neterminal.id}).distinct.count(:incognito_token)
    end

  end


  def validate_request(id)
    parameters = evaluation_session_params

    if id.to_i > 0
      @evaluation_session = EvaluationSession.find(id)
    else
      @evaluation_session = EvaluationSession.new
      @evaluation_session.year = if Date.today.month > 8 then
                                   Date.today.year
                                 else
                                   Date.today.year - 1
                                 end
      @evaluation_session.semester = parameters['semester']
      @evaluation_session.status = 'Planificata'
    end
    if id.to_i > 0 and @evaluation_session.status == 'Activa'

    else

      # chestionar curs
      if parameters['from_upload'] == '1'
        if parameters['form1'].nil?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru curs'

        else
          begin
            @chestionar = xml_file_to_json_string parameters['form1']
          ensure
            @evaluation_session.errors[:base] << 'Fisierul furnizat nu respecta formatul' unless @chestionar
          end
        end

      else
        if parameters['form2'].nil? or parameters['form2'].empty?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru curs'
        else
          if id == 0 or (id > 0 and @evaluation_session.form_id != parameters['form2'])
            copied = Form.find(parameters['form2'])
            @evaluation_session.form_id = copied.id
            # @chestionar = copied.content
            # @chestionar_title = copied.title + '-' + Date.today.to_time.to_i.to_s
          end
        end
      end

      #chestionar seminar
      if parameters['from_uploadS'] == '1'
        if parameters['formS1'].nil?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru seminar'

        else
          begin
            @chestionar_S = xml_file_to_json_string parameters['formS1']
          ensure
            @evaluation_session.errors[:base] << 'Fisierul furnizat nu respecta formatul' unless @chestionar_S
          end
        end

      else
        if parameters['formS2'].nil? or parameters['formS2'].empty?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru seminar'
        else
          if id == 0 or (id > 0 and @evaluation_session.formS_id != parameters['formS2'])
            copied = Form.find(parameters['formS2'])
            @evaluation_session.formS_id = copied.id
            # @chestionar_S = copied.content
            #@chestionar_S_title = copied.title + '-' + Date.today.to_time.to_i.to_s
          end
        end
      end
      #chestionar lab
      if parameters['from_uploadL'] == '1'
        if parameters['formL1'].nil?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru laborator'

        else
          begin
            @chestionar_L = xml_file_to_json_string parameters['formL1']
          ensure
            @evaluation_session.errors[:base] << 'Fisierul furnizat nu respecta formatul' unless @chestionar_L
          end
        end

      else
        if parameters['formL2'].nil? or parameters['formL2'].empty?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru laborator'
        else
          if id == 0 or (id > 0 and @evaluation_session.formL_id != parameters['formL2'])
            copied = Form.find(parameters['formL2'])
            @evaluation_session.formL_id = copied.id
            #@chestionar_L = copied.content
            #@chestionar_L_title = copied.title + '-' + Date.today.to_time.to_i.to_s
          end
        end
      end
      #chestionar Proiect
      if parameters['from_uploadP'] == '1'
        if parameters['formP1'].nil?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru proiect'

        else
          begin
            @chestionar_P = xml_file_to_json_string parameters['formP1']
          ensure
            @evaluation_session.errors[:base] << 'Fisierul furnizat nu respecta formatul' unless @chestionar_P
          end
        end

      else
        if parameters['formP2'].nil? or parameters['formP2'].empty?
          @evaluation_session.errors[:base] << 'Va rugam specificati un formular pentru proiect'
        else
          if id == 0 or (id > 0 and @evaluation_session.formP_id != parameters['formP2'])
            copied = Form.find(parameters['formP2'])
            @evaluation_session.formP_id = copied.id
            #@chestionar_L = copied.content
            #@chestionar_L_title = copied.title + '-' + Date.today.to_time.to_i.to_s
          end
        end
      end
    end
    if parameters['start_date'].nil?
      @evaluation_session.errors[:base] << 'Va rugam selectati data de incepere pentru anii neterminali'
    else
      @evaluation_session.start_date = parse_date parameters['start_date']
      @evaluation_session.errors[:base] << 'Data incepere ani neterminali este gresit formatata' unless @evaluation_session.start_date
    end

    if parameters['end_date'].nil?
      @evaluation_session.errors[:base] << 'Va rugam selectati data de final pentru anii neterminali'
    else
      @evaluation_session.end_date = parse_date parameters['end_date']
      @evaluation_session.errors[:base] << 'Data final ani neterminali este gresit formatata' unless @evaluation_session.end_date
    end
    if parameters['terminal'] == '1'
      @evaluation_session.terminal = true
    else
      @evaluation_session.terminal = false
    end

  end

  def parse_date(data)
    Date.strptime data, '%d-%m-%Y'
  rescue
    nil
  end


  def getAllEvaluationSessions(terminal)
    all = EvaluationSession.where(terminal: terminal)

    return all.sort_by {|session| [session.sort_val, session.id]}.reverse
  end


  def add_evaluation_session_activities (session)
    copied_ids = []
    year = if Date.today.month > 8 then
             Date.today.year
           else
             Date.today.year - 1
           end
    Cohort.where(is_terminal: session.terminal).each do |cohort|
      eval_cohort = EvaluationSessionCohort.new name: cohort.name, is_terminal: cohort.is_terminal, students_number: cohort.students_number, optionals_number: cohort.optionals_number, department: cohort.department, evaluation_session: session
      eval_cohort.save
      copied_ids[cohort.id] = eval_cohort.id
      Activity.where(cohort: cohort, semester: session.semester).each do |activity|
        eval_activity = EvalSessionActivity.new course: activity.course, is_optional: activity.is_optional, teacher: activity.teacher, year: year, semester: activity.semester, activity_type: activity.activity_type, evaluation_session: session, evaluation_session_cohort: eval_cohort
        eval_activity.save
      end
    end


  end


  # Generates a random string from a set of easily readable characters
  def generate_activation_code(size = 16)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z a b c d e f g h j k  m n p q r s t u v w x y z = + / }
    (0...size).map {charset.to_a[rand(charset.size)]}.join
  end

  def generate_tokens(session)

    require 'securerandom'
    ActiveRecord::Base.transaction do
      delete_all_tokens(session)
      EvaluationSessionCohort.where(evaluation_session: session).each do |g|
        if g.students_number and g.is_terminal == session.terminal
          g.students_number.times do
            rand = generate_activation_code
            while IncognitoUser.find_by_token(rand)
              rand = generate_activation_code
            end
            IncognitoUser.create(evaluation_session_cohort: g, token: rand, evaluation_session: session)
          end
        end
      end
      session.last_refresh = DateTime.now
      session.save
    end
  end


  def get_votes(completed_for_activity, qindex, no)

    results = []
    if no.nil? || no == 0

    else

      (0..no).each do |rindex|
        results[rindex] = 0
      end
      completed_for_activity.each do |result|

        results[result[qindex.to_s].to_i] += 1
      end
      #  puts 'results ' + results.inspect.to_s

    end
    results
  end


  def delete_all_tokens(session)
    tokens = IncognitoUser.where(evaluation_session: session)
    tokens.each do |token|
      ActiveIncognitoUser.where(incognito_user_token: token.token).delete_all
    end
    tokens.delete_all
  end

end
