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

class EvalSessionActivity < ActiveRecord::Base
  belongs_to :course
  belongs_to :evaluation_session_cohort
  belongs_to :teacher
  belongs_to :evaluation_session
  has_many :completed_evaluations, dependent: :destroy

  attr_accessor :cohorts
  attr_accessor :activities
  attr_accessor :evaluated

  def completed(token)
    CompletedEvaluation.find_by_incognito_token_and_eval_session_activity_id(token, self.id).nil? ? false : true
  end

  def get_answer(qindex)
    content = CompletedEvaluation.where(eval_session_activity_id: self.id).pluck(:content)

    require 'json'
    jcontent = []
    content.each do |q|
      jcontent << JSON.load(q)[qindex.to_s]
    end

    jcontent

  end


  def can_be_evaluated(token)
=begin
    if self.completed(token) == true
      return false
    end

    if self.is_optional == true
      activities =
      if self.activity_type != 'Curs'
        course = EvalSessionActivity.find_by_course_id_and_activity_type(self.course_id, 'Curs')
      else

      end
    else


    end

=end

  end
end
