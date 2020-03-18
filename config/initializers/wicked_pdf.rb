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

# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.config = {
  # Path to the wkhtmltopdf executable: This usually isn't needed if using
  # one of the wkhtmltopdf-binary family of gems.
  # exe_path: '/usr/local/bin/wkhtmltopdf',
  #   or
  # exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')

  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  # layout: 'pdf.html',
}
