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

module EvaluationHelper


  def get_courses_for_cohort
    @activities = EvalSessionActivity.where(evaluation_session_cohort_id: @current_user_token.evaluation_session_cohort.id).order(:course_id)


    @optionals = @activities.where(is_optional: true)
    @mandatories1 = @activities.where(is_optional: false)

    @mandatories2 = {}
    @mandatories1.each do |a_hash|

      @mandatories2[a_hash[:course_id]] ||= []
      @mandatories2[a_hash[:course_id]] << a_hash

    end
    @mandatories = []
    @mandatories2.each do |key, val|
      @mandatories << {'course': Course.find_by_id(key), 'activities': val}
    end
    @out = {}
    @optionals.each do |a_hash|
      a_hash.evaluated = a_hash.completed(@current_user_token.token)
      @out[a_hash[:course_id]] ||= []
      @out[a_hash[:course_id]] << a_hash

    end

    @optional_activities = []

    @out.each do |key, val|
      @optional_activities << {'course': Course.find_by_id(key), 'activities': val, 'is_evaluated': is_eval(val)}
    end
    @number_of_evaluated_optionals = number_of_evaluated_optionals(@optional_activities)

  end

  def can_be_eval(opt_activity)
    if opt_activity[:is_evaluated] == false and @number_of_evaluated_optionals == @current_user_token.evaluation_session_cohort.optionals_number
      return false
    end
    return true
  end

  def is_eval(activities)
    activities.each do |activity|
      if activity.evaluated == true
        return true
      end
    end
    return false
  end

  def number_of_evaluated_optionals(opt_act)
    count = 0
    opt_act.each do |act|
      if act[:is_evaluated]
        count += 1
      end
    end
    return count
  end
end
