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

class TokensPdf < Prawn::Document

  def initialize(session)
    super()
    generate(session)
  end

  def generate(session)
    cohorts = EvaluationSessionCohort.where evaluation_session: session
    cohorts.each do |g|
      i_users = IncognitoUser.where evaluation_session_cohort: g

      if i_users.any?

        text_box "Grupa #{g.name}, Nr studenti #{i_users.count}", :at => [200, cursor-20]
        move_down 50

        data = []

        i_users.each_slice(2) do |a, b|

          cell_1 = make_cell(:content => "Grupa #{g.name}\n#{a.token}\nValabil pana la #{session.end_date.strftime("%d-%m-%Y")}\nhttp://evaluare.fmi.unibuc.ro")
          if b
            cell_2 = make_cell(:content => "Grupa #{g.name}\n#{b.token}\nValabil pana la #{session.end_date.strftime("%d-%m-%Y")}\nhttp://evaluare.fmi.unibuc.ro")
            data << [cell_1, cell_2]
          else
            data << [cell_1]
          end

        end

        # # data += [[cell_1, nil]] if i_users.count % 2 == 1

        table(data, :width => 450) #, :cell_style => {:align=> :center, :height => 70,:padding => 15})
        start_new_page
      end

    end
  end
end


