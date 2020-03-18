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

class UserSessionsController < ApplicationController
  before_filter :login_required, :only => [:destroy]

  respond_to :html

  # omniauth callback method
  def create

    cookies[:selection] = nil
    omniauth = env['omniauth.auth']
    logger.debug "+++ #{omniauth}"

    user = User.find_by uid: omniauth['uid']
    if not user
      # New user registration
      user = User.new(:uid => omniauth['uid'])
    end
    user.first_name = omniauth['extra']['first_name']
    user.last_name = omniauth['extra']['last_name']
    user.email = omniauth['extra']['email']
    user.is_student = omniauth['extra']['student']
    user.is_teacher = omniauth['extra']['teacher']
    user.is_management = omniauth['extra']['management']
    user.is_admin = omniauth['extra']['admin']
    user.token = omniauth['credentials']['token']
    user.save

    #p omniauth

    # Currently storing all the info
    session[:user_id] = omniauth
    @current_user = omniauth

    flash[:notice] = 'Successfully logged in'
    print user.inspect
    if user.is_admin == 'true'
      redirect_to admin_path
    elsif user.is_teacher == 'true'
      redirect_to prof_index_path
    else
      destroy
    end
  end

  # Omniauth failure callback
  def failure
    flash[:notice] = params[:message]

  end

  # logout - Clear our rack session BUT essentially redirect to the provider
  # to clean up the Devise session from there too !
  def destroy
    session[:user_id] = nil

    # flash[:notice] = 'You have successfully signed out!'
    redirect_to "#{CUSTOM_PROVIDER_URL}/users/sign_out"
  end

  def user_params
    params.require(:user).permit(:uid, :first_name, :last_name)
  end
end
