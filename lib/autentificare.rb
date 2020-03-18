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

require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Autentificare < OmniAuth::Strategies::OAuth2

      CUSTOM_PROVIDER_URL = 'http://193.226.51.30/'

      option :client_options, {
        :site =>  CUSTOM_PROVIDER_URL,
        :authorize_url => "#{CUSTOM_PROVIDER_URL}/auth/autentificare/authorize",
        :access_token_url => "#{CUSTOM_PROVIDER_URL}/auth/autentificare/access_token"
      }

      uid { raw_info['id'] }

      info do
        {
          :email => raw_info['email']
        }
      end

      extra do
        {
          :first_name => raw_info['extra']['first_name'],
          :last_name  => raw_info['extra']['last_name'],
          :email => raw_info['extra']['email'],
          :student  => raw_info['extra']['student'],
          :teacher => raw_info['extra']['teacher'],
          :management  => raw_info['extra']['management'],
          :admin  => raw_info['extra']['admin']
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/auth/autentificare/user.json?oauth_token=#{access_token.token}").parsed
      end
    end
  end
end
