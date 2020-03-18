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

class CoursesController < AdminController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  respond_to :html, :js

  include CoursesHelper

  def index
    get_courses
  end

  def course_list
    if params['department'] != ''
      @courses = Course.order(:title).where(department_id: params['department'])
    else
      @courses = Course.order(:title)
    end
    respond_to do |format|
      format.js
    end
  end


  def edit
  end

  def update
    @course.update(course_params)
    get_courses
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.save
    get_courses
    respond_to do |format|
      format.js
    end
  end

  def delete
    @course = Course.find(params[:course_id])
  end

  def destroy
    @course.destroy
    get_courses
  end

  require 'csv'

  def import
    @errors =[]
    if request.post?
      CSV.parse params[:csv] do |row|
        dep = Department.find_by_name(row[1].to_s.squish)
        if !dep.nil?
          Course.create(title: row[0].to_s.squish,  department_id: dep.id)
        end

      end
      get_courses
    end
    respond_to do |format|
      format.js
    end
  end

  def download
    courses = []

    Course.pluck(:title,  :department_id).each do |course|
      course << Department.find_by_id(course[1]).name
      courses << course
    end
    send_data course_as_csv(courses), filename: "Materii.csv", type: 'application/csv', disposition: 'attachment'
  end

=begin

  def reset

    if request.post?
      # str = "#{CUSTOM_PROVIDER_URL}/students/#{@current_user.uid}?oauth_token=#{@current_user.token}"
      str = "http://193.226.51.18/students/#{@current_user.uid}?oauth_token=#{@current_user.token}"


      #:8091
       @info = JSON.parse(open(str).read)

       print @info
    end

    @courses = Course.all

  end
=end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  def get_courses
    @courses = Course.order(:title)
    @departments_select = Department.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:title, :department_id)
  end
end
