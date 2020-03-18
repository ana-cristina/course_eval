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

class TeachersController < AdminController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  respond_to :html, :js


  def index
    get_all_teachers
  end


  def show
  end


  def new
    @teacher = Teacher.new
  end


  def edit
  end


  def create
    @teacher = Teacher.new(teacher_params)
    @teacher.save
    get_all_teachers
    respond_to do |format|
      format.js
    end
  end


  def update
    @teacher.update(teacher_params)
    get_all_teachers
  end


  def destroy
    @teacher.destroy
    get_all_teachers
  end

  def delete
    @teacher = Teacher.find(params[:teacher_id])
  end


  require 'csv'

  def import
    @errors =[]
    if request.post?
      CSV.parse params[:csv] do |row|
        Teacher.create(first_name: row[1].to_s.squish, last_name: row[0].to_s.squish)
      end
      get_all_teachers
    end


    respond_to do |format|
      format.js
    end
  end

  def download
    teachers = Teacher.all

    send_data teachers.as_csv, filename: "Profesori.csv", type: 'application/csv', disposition: 'attachment'
  end

  require 'net/http'
  require 'rest_client'
  require 'json'

  def import_from_app
    @errors =[]

    str = "#{API_URL}teachers?oauth_token=#{@current_user.token}"
    info = JSON.parse RestClient.get str, {:accept => :json}

    if not info['error'].nil?
      redirect_to logout_path
      return
    end

    print info['data'].inspect

    info['data'].each do |ch|
      department_name = ch['department'] == 'TCI' ? 'CTI' : ch['department']

      department = Department.find_by_name department_name

      teacher = Teacher.find_by_first_name_and_last_name ch['first_name'], ch['last_name']
      if teacher.nil?
        teacher = Teacher.new
      end

      teacher.first_name = ch['first_name']
      teacher.last_name = ch['last_name']
      teacher.email = ch['email']
      teacher.department = department

      teacher.save
    end
    get_all_teachers

    respond_to do |format|
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def get_all_teachers
    @teachers = Teacher.order(:last_name)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :email)
  end
end
