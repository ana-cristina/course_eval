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

module AdminHelper

  require 'nokogiri'
  require 'json'

  def xml_file_to_json_string(file)
    @chestionar_title = File.basename file.original_filename, '.xml'
    doc = Nokogiri::XML file.read
    raise 'Tag-ul chestionar nu-i la locul lui' unless doc.child.node_name == 'chestionar'
    chestionar = []
    doc.child.element_children.each do |elem|
      if elem.node_name == 'sectiune'
        sectiune = []
        elem.element_children.each do |elem1|
          if elem1.node_name == 'label'
            sectiune << {'label' => elem1.content}
          elsif elem1.node_name == 'intrebare'
            intrebare = []
            elem1.element_children.each do |elem2|
              case elem2.node_name
                when 'enunt'
                  intrebare << {'enunt' => elem2.content}
                when 'rasp'
                  intrebare << {'rasp' => elem2.content}
                else
                  raise 'Tag necunoscut'
              end
            end
            sectiune << {'intrebare' => intrebare}
          else
            raise 'Tag necunoscut'
          end
        end
        chestionar << sectiune
      end
    end
    return {'chestionar' => chestionar}.to_json
  rescue
    raise 'Eroare parsare fisier'
  end


end
