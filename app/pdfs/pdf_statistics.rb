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

class PdfStatistics < Prawn::Document

  def initialize(courseId, teacherId, type, active_session)
    @course = Course.find_by_id(courseId)
    @teacher = Teacher.find_by_id(teacherId)
    @activityType = type

    @session_activities = EvalSessionActivity.where(course_id: courseId,
                                                    teacher_id: teacherId,
                                                    activity_type: type,
                                                    evaluation_session_id: active_session)
    @current_session = EvaluationSession.find_by_id(active_session)
    super()
    generate
  end

  def generate
=begin
    if @session_activities and @session_activities.size > 0

      cohorts = EvaluationSessionCohort.where(id: @session_activities.pluck(:evaluation_session_cohort_id)).pluck(:name).join ', '

      year = "#{ @current_session.year} - #{ @current_session.year + 1}"


      semester = @current_session.semester


      header_text = "#{@activityType}: #{@course.title}\nProfesor: #{@teacher.last_name} #{@teacher.first_name}\nGrupe: #{cohorts}\nAn: #{year}           Semestru: #{semester}"

      questions = @current_session.form.get_radio_questions
      header_box do
        font('Helvetica', :size => 16) do
          text(header_text, :color => BROWN, :valign => :center)
        end
      end

      questions.each do |question|
        text question[:text], :size => 16, :style => :bold, :align => :center
        answers = []
        @session_activities.each do |activity|
          answers << activity.get_answer(question[:index])
        end
        answers.flatten!
        if answers.any?
          answers.each do |answer|
            text "     >>    #{answer}"
            move_down 20
          end
        else
          text 'nici un raspuns'
        end
      end

    else
      text 'Eroare: acest curs nu a putut fi gasit'
    end
  end


  BOX_MARGIN = 36
  RHYTHM = 10
  BLACK = "000000"
  LIGHT_GRAY = "F2F2F2"
  GRAY = "DDDDDD"
  DARK_GRAY = "333333"
  BROWN = "A4441C"
  ORANGE = "F28157"
  LIGHT_GOLD = "FBFBBE"
  DARK_GOLD = "EBE389"
  BLUE = "0000D0"
  INNER_MARGIN = 30
  LEADING = 2

  def header_box(&block)

    bounding_box([-bounds.absolute_left, cursor + BOX_MARGIN],
                 :width => bounds.absolute_left + bounds.absolute_right,
                 :height => BOX_MARGIN*2 + RHYTHM*2) do

      fill_color LIGHT_GRAY
      fill_rectangle([bounds.left, bounds.top],
                     bounds.right,
                     bounds.top - bounds.bottom)
      fill_color BLACK

      indent(BOX_MARGIN + INNER_MARGIN, &block)
    end

    stroke_color GRAY
    stroke_horizontal_line(-BOX_MARGIN, bounds.width + BOX_MARGIN, :at => cursor)
    stroke_color BLACK

    move_down(RHYTHM*3)
=end
  end

end