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

class StatisticsController < AdminController
  include StatisticsHelper
  require 'csv'


  def index
    @current_tab = 'statistici'
    @all_sessions = EvaluationSession.where(status: "Finalizata")
    @courses = Course.all
    @teachers = Teacher.order(:last_name)
  end

  def course_statistics
    @current_tab = 'statistici'

    @course = Course.find_by_id(params['course_id'])

    ids = EvalSessionActivity.where(course_id: params['course_id']).pluck(:evaluation_session_id)
    @evaluation_sessions = EvaluationSession.order(:start_date).where(id: ids).reverse_order

  end

  def teacher_statistics
    @current_tab = 'statistici'

    @teacher = Teacher.find_by_id(params['teacher_id'])

    ids = EvalSessionActivity.where(teacher_id: params['teacher_id']).pluck(:evaluation_session_id)
    @evaluation_sessions = EvaluationSession.order(:start_date).where(id: ids).reverse_order

  end

  def download_by_cohorts
    # ids=[16,17,20,21,26,27,30,31]

    #ids = [36,38,39,42,35,37,40,41]

    # ids = [43,44,45,46,47,48,49,50]
    ids = [54, 57, 59, 55, 56, 58]

    #ids = EvaluationSession.all.pluck(:id)
    downloadable = []
    downloadable << 'Id Sesiune, Grupa, Nr Studenti'
    ids.each do |id|
      sql = "SELECT count( distinct incognito_token), evaluation_session_cohorts.name
            FROM
              public.completed_evaluations,
              public.eval_session_activities,
              public.evaluation_sessions,
              public.evaluation_session_cohorts
            WHERE
              completed_evaluations.eval_session_activity_id = eval_session_activities.id AND
              eval_session_activities.evaluation_session_id = evaluation_sessions.id AND
              evaluation_session_cohorts.id = eval_session_activities.evaluation_session_cohort_id AND
               (evaluation_sessions.id = #{id.to_s})
            group by evaluation_session_cohorts.name;"
      records_array = ActiveRecord::Base.connection.execute(sql).values


      records_array.each do |record|
        downloadable << id.to_s + ',' + record[1] + ',' + record[0].to_s
      end
    end
    downloadable = downloadable.join("\n")

    send_data downloadable, :type => 'text/csv; charset=iso-8859-1; header=present', filename: "raport_grupe.csv"


  end

  def download_all()

    #ids=[16,17,20,21,26,27,30,31]
    #ids = [36,38,39,42,35,37,40,41]

    #   ids = [43,44,45,46,47,48,49,50]
    ids = [54, 57, 59, 55, 56, 58]
    # ids = EvaluationSession.all.pluck(:id)
    sql = "SELECT evaluation_sessions.id as id, evaluation_sessions.semester as semestru ,
             concat( concat( teachers.last_name, ' ') ,  teachers.first_name) as nume, courses.title as materie,
             eval_session_activities.activity_type as tip, completed_evaluations.content as continut
            FROM
              public.courses,
              public.teachers,
              public.eval_session_activities,
              public.evaluation_sessions,
              public.completed_evaluations
            WHERE
              eval_session_activities.course_id = courses.id AND
              eval_session_activities.teacher_id = teachers.id AND
              eval_session_activities.evaluation_session_id = evaluation_sessions.id AND
              eval_session_activities.id = completed_evaluations.eval_session_activity_id and
              (evaluation_sessions.id in (#{ids.join(', ')}))
            Order by evaluation_sessions.id, evaluation_sessions.semester , teachers.last_name, teachers.first_name,courses.title, eval_session_activities.activity_type ;"
    records_array = ActiveRecord::Base.connection.execute(sql).values

    downloadable = []
    downloadable << ['id', 'semestru', 'nume', 'materie', 'tip', 'continut'].join(',')
    records_array.each do |record|
      record[5] = record[5].gsub(',', ';')
      downloadable << record.join(',')
    end
    downloadable = downloadable.join("\n")


    send_data downloadable, :type => 'text/csv; charset=iso-8859-1; header=present', filename: "raport.csv"

  end

  def download_all_pdf
    #ids = [54, 57, 59, 55, 56, 58]
    #ids = [1, 2]
    ids = []
    ids = unless params[:id].nil? || params[:id].empty?
            [params[:id]]
          end

    root = DOCUMENTS_PATH
    pathi = File.join(root, 'evaluari')
    if Dir.exist?(root)
      FileUtils.rm_rf([root])
    end
    system 'mkdir', '-p', root.to_s

    system 'mkdir', '-p', pathi.to_s

    teachers = Teacher.all

    evaluation_sessions = EvaluationSession.where(id: ids)

    evaluation_sessions.each do |current_session|
      teachers.each do |teacher|

        Course.all.each do |course|

          TYPES.each do |type|
            eval_session_activities = EvalSessionActivity.where(
                teacher_id: teacher.id,
                evaluation_session_id: current_session.id,
                course_id: course.id,
                activity_type: type)
            if eval_session_activities && eval_session_activities.size > 0
              begin
                pdf1 = PdfComments.new(course.id, teacher.id, type, current_session)
                path1 = File.join(pathi, "#{teacher.last_name} #{teacher.first_name} #{course.title}-#{type} - comentarii.pdf".force_encoding('UTF-8'))
                pdf1.render_file(path1)
              rescue => e
                print e
              end
              begin
                path2 = File.join(pathi, "#{teacher.last_name} #{teacher.first_name} #{course.title}-#{type} - grila.pdf".force_encoding('UTF-8'))
                pdf2 = generate_evaluation_questions(course, teacher, type, current_session, eval_session_activities)

                pdf2.to_file(path2)
              rescue => e
                print e
              end
            end
          end
        end
      end
    end

    zipfile_name = File.join(root, 'evaluari.zip')
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      Dir.children(pathi).each do |filename|

        zipfile.add(filename, File.join(pathi, filename))
      end

    end
    send_file(zipfile_name, :type => 'application/zip', :filename => 'evaluari.zip')
  end

end
