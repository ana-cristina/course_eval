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

class EvaluationSession < ActiveRecord::Base
  belongs_to :form
  belongs_to :formS, :class_name => 'Form'
  belongs_to :formL, :class_name => 'Form'
  belongs_to :formP, :class_name => 'Form'
  has_many :eval_session_activities, dependent: :destroy
  has_many :evaluation_session_cohorts, :dependent => :destroy
  has_many :incognito_users, dependent: :destroy


  attr_accessor :from_upload
  attr_accessor :form1
  attr_accessor :form2
  attr_accessor :from_uploadL
  attr_accessor :formL1
  attr_accessor :formL2
  attr_accessor :from_uploadS
  attr_accessor :formS1
  attr_accessor :formS2
  attr_accessor :from_uploadP
  attr_accessor :formP1
  attr_accessor :formP2
  # Getter
  def session_status
    if self.end_date < Date.today
      if self.status != 'Finalizata'
        self.update(status: 'Finalizata')
      end
      'Finalizata'
    else
      self.status
    end
  end
  def sort_val
    return 2 if self.session_status == 'Activa'
    return 1 if self.session_status == 'Planificata'
    return 0 if self.session_status == 'Finalizata'
  end

  def identifier
    "#{year} - #{year+1} semestru #{semester} #{start_date.strftime('%d/%m')} - #{end_date.strftime('%d/%m')} "
  end

end
