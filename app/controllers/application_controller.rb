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

class ApplicationController < ActionController::Base
  protect_from_forgery

  API_URL = 'http://193.226.51.30/api/V2/'

  def login_required
    if !current_user
      respond_to do |format|
        format.html {
          redirect_to '/auth/autentificare'
        }
        format.json {
          render :json => {'error' => 'Access Denied'}.to_json
        }
      end
    end
  end

  def admin_only
    if @current_user.is_admin == 'false'
      respond_to do |format|
        format.html {
          redirect_to logout_path
        }
        format.json {
          render :json => {'error' => 'Access Denied'}.to_json
        }
      end
    end
  end

  def prof_only
    if @current_user.is_teacher == 'false'
      respond_to do |format|
        format.html {
          redirect_to logout_path
        }
        format.json {
          render :json => {'error' => 'Access Denied'}.to_json
        }
      end
    end
  end

  def current_user
    return nil unless session[:user_id]
    @current_user ||= User.find_by uid: session[:user_id]['uid']
  end


  def token_login_redirect
    if current_user_token
      redirect_to evaluate_path
    end
  end

  def current_user_token
    return nil unless session[:user_token]
    @current_user_token ||= IncognitoUser.find_by_token session[:user_token]['token']
  end

  def token_login_required
    if !current_user_token
      respond_to do |format|
        format.html {
          redirect_to home_index_path
        }
        format.json {
          render :json => {'error' => 'Access Denied'}.to_json
        }
      end
    end
  end

end
