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

class HomeController < ApplicationController
  include HomeHelper

  def index
    @errors = {}
    token_login_redirect
    get_active_evaluation_session
  end


  def create
    @errors = {}
    get_active_evaluation_session
    if params[:token].blank?
      @errors[:error] = 'Nu te poti loga cu un camp gol!'
      print 'Nu te poti loga cu un camp gol!'
      render 'index' and return
    end
    i_user = IncognitoUser.find_by_token params[:token].strip
    if i_user
#check if there is any active evaluation session

      if @active_session.nil? and @active_session_neterminal.nil?
        @errors[:error] = 'Momentan nu puteti evalua nici un curs'
        print 'Momentan nu puteti evalua nici un curs'
        render 'index' and return
      end

      if i_user.evaluation_session.status != 'Activa'
        @errors[:error] = 'Token invalid'
        print 'Token invalid'
        render 'index' and return
      end

      session[:user_token] = {token: i_user.token, cohort: i_user.evaluation_session_cohort, eval_session: i_user.evaluation_session}

      user_session = ActiveIncognitoUser.find_by_incognito_user_token(i_user.token)
      if user_session
        if user_session.start_date > Time.now-600
          @errors[:error] = 'Ne pare rau dar proprietarul token-ului este deja logat'
          print 'Ne pare rau dar proprietarul token-ului este deja logat'
          render 'index'
        else
          user_session.update_attributes(start_date: Time.now)
          redirect_to evaluate_path
        end
      else
        ActiveIncognitoUser.create(incognito_user_token: i_user.token, start_date: Time.now)
        redirect_to evaluate_path
      end

    else
      @errors[:error] = 'Token Invalid'
      print 'Token Invalid'
      render 'index'
    end

  end

  def abort_token_session
    #flash.keep
    if session[:user_token]
      user_session = ActiveIncognitoUser.find_by_incognito_user_token(session[:user_token]['token'])
      user_session.destroy if user_session
      session[:user_token] = nil
    end
    redirect_to root_path
  end
end
