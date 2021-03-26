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

class FormsController < AdminController
  before_action :set_form, only: [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  include FormsHelper
  respond_to :html, :js

  # GET /forms
  # GET /forms.json
  def index
    @forms = Form.all.order(:id)
    @current_tab = 'chestionare'
  end

  # GET /forms/1
  # GET /forms/1.json
  def show
    id = 0
    if params[:form_id].present?
      id = params[:form_id]
    else
      if params[:id].present?
        id = params[:id]
      end
    end
    @form = Form.find(id)
    require 'json'
    form_content = JSON.parse @form.content
    @content = form_content["chestionar"]
  end

  # GET /forms/new
  def new
    @form = Form.new
  end

  # GET /forms/1/edit
  def edit
  end

  # POST /forms
  # POST /forms.json
  def create

    validate_request

    if @form.errors.any?
    else
      @form.save
    end
    @forms = Form.all.order(:id)
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /forms/1
  # PATCH/PUT /forms/1.json
  def update
    @form = Form.find(params[:id])
    @form.update_attributes(form_params)
    @forms = Form.all.order(:id)
  end

  def delete
    @form = Form.find(params[:form_id])
  end

  # DELETE /forms/1
  # DELETE /forms/1.json
  def destroy
    @form = Form.find(params[:id])
    @form.destroy
    @forms = Form.all.order(:id)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_form
    @form = Form.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def form_params
    params.require(:form).permit(:title, :content, :form1)
  end
end
