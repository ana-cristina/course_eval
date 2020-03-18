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

module FormsHelper
  include AdminHelper

  def validate_request
    parameters = form_params
    @form = Form.new

    if parameters['form1'].nil?
      @form.errors[:base] << 'Va rugam specificati un formular'
    else
      begin
        @chestionar = xml_file_to_json_string parameters['form1']
        @form.content = @chestionar
      ensure
        @form.errors[:base] << 'Fisierul furnizat nu respecta formatul' unless @chestionar
      end
    end

    if parameters['title'].nil? or parameters['title'].empty?
      @form.title = @chestionar_title if @chestionar_title
    else
      @form.title = parameters['title']
    end
  end
end
