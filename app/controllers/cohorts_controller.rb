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

class CohortsController < AdminController
  before_action :set_cohort, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  respond_to :html, :js
  include CohortsHelper

  def index
    @cohorts = Cohort.all
    @departments_select = Department.all
  end

  def cohort_list
    if params['department'] != ''
      @cohorts = Cohort.order(:name).where(department_id: params['department'])
    else
      @cohorts = Cohort.order(:name)
    end
    respond_to do |format|
      format.js
    end
  end


  def edit
  end

  def update
    @cohort.update(cohort_params)
    @cohorts = Cohort.all
    @departments_select = Department.all
  end

  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new(cohort_params)
    @cohort.save
    @cohorts = Cohort.all
    @departments_select = Department.all
    respond_to do |format|
      format.js
    end
  end

  def delete
    @cohort = Cohort.find(params[:cohort_id])
  end

  def destroy
    @cohort.destroy
    @departments_select = Department.all
    @cohorts = Cohort.all
  end

  require 'csv'

  def import
    @errors =[]
    if request.post?
      CSV.parse params[:csv] do |row|
        dep = Department.find_by_name(row[4].to_s.squish)
        terminal = row[1].to_s.squish.downcase == 'da' ? true : false
        if !dep.nil?
          Cohort.create(name: row[0].to_s.squish, is_terminal: terminal, students_number: row[2], optionals_number: row[3], department_id: dep.id)
        end

      end
      @cohorts = Cohort.all
      @departments_select = Department.all
    end
    respond_to do |format|
      format.js
    end
  end

  def download

    cohorts = []

    Cohort.pluck(:name, :is_terminal, :students_number, :optionals_number, :department_id).each do |cohort|
      cohort[1] = cohort[1] == true ? 'DA' : 'NU'
      cohort[4] = Department.find_by_id(cohort[4]).name

      cohorts << cohort
    end
    send_data cohorts_as_csv(cohorts), filename: "Grupe.csv", type: 'application/csv', disposition: 'attachment'
  end


  require 'net/http'
  require 'rest_client'
  require 'json'

  def import_from_app
    @errors =[]
    str = "#{API_URL}groups?oauth_token=#{@current_user.token}"
    info = JSON.parse RestClient.get str, {:accept => :json}

    if not info['error'].nil?
      redirect_to logout_path
      return
    end


    print info['data'].inspect

    info['data'].each do |ch|

      # TODO cohort.optionals_number

      old_cohort = Cohort.find_by_name ch[0]

      department_name = ch[1]['domeniu'] == 'TCI' ? 'CTI' : ch[1]['domeniu']
      department = Department.find_by_name department_name
      if old_cohort.nil?
        cohort = Cohort.new
        cohort.name = ch[0]
        cohort.is_terminal = ch[1]['an_terminal'] == 'DA'
        cohort.department = department
        cohort.students_number = ch[1]['numar_studenti']
        cohort.save
      else
        old_cohort.is_terminal = ch[1]['an_terminal'] == 'DA'
        old_cohort.department = department
        old_cohort.students_number = ch[1]['numar_studenti']
        old_cohort.save
      end

    end
    @cohorts = Cohort.all
    @departments_select = Department.all
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_cohort
    @cohort = Cohort.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cohort_params
    params.require(:cohort).permit(:name, :is_terminal, :students_number, :optionals_number, :department_id)
  end
end
