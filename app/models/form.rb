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

class Form < ActiveRecord::Base
  attr_accessor :form1


  def is_used
    session = EvaluationSession.find_by_form_id self.id
    if session.nil?
      false
    else
      true
    end
  end

  def get_text_questions
    require 'json'
    j = JSON.load self.content
    return [] unless j['chestionar']

    contents = j['chestionar']
    answers = []
    nr = 0

    contents.each do |section|
      section.each do |parent|
        question = parent["intrebare"]
        if question
          if question.count == 1 and question.first['enunt']
            answers << {index: nr + 1, text: question.first['enunt']}
          end
          nr = nr + 1
        end
      end
    end

    return answers
  end
end
