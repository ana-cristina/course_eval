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

# Change this omniauth configuration to point to your registered provider
# Since this is a registered application, add the app id and secret here

APP_ID = '40bdbf19-c166-47ac-a156-da7d26684c94'
APP_SECRET = '63693cc186cb7dcdfdf8d569467d25cb44d1748e068cbaca41'

CUSTOM_PROVIDER_URL = 'http://193.226.51.30/'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :autentificare, APP_ID, APP_SECRET
end
