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

class AdminController < ApplicationController
  before_action :login_required
  before_action :admin_only
  # before_action :signed_login_required, only: [:abort_signed_session]
  # before_action :token_login_required, only: [:abort_token_session]

  def index

  end

  def show

  end


  def edit
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if password && password == password_confirmation && password.length >= 8
      current_user.password = password
      current_user.save!
      flash.now[:alert] = "The password has been changed successfully!"
      redirect_to admin_url, notice: "Password changed!"
    else
      flash.now[:alert] = "The passwords don't match or password contains less than 8 characters"
      render "show"
    end
  end
end
