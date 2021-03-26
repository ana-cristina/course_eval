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

class EvaluationController < ApplicationController
  before_action :token_login_required
  skip_before_action :verify_authenticity_token

  include EvaluationHelper
  respond_to :html, :js


  def index
    get_courses_for_cohort
  end

  def eval_form
    @activity = EvalSessionActivity.find(params[:activity_id])

    @completed_activity = CompletedEvaluation.find_by_incognito_token_and_eval_session_activity_id(@current_user_token.token, @activity.id)

    if @activity and !@completed_activity
      if @activity.activity_type == 'Curs'
        @form = @activity.evaluation_session.form
      else
        if @activity.activity_type == 'Seminar'
          @form = @activity.evaluation_session.formS
        else
          if @activity.activity_type == 'Laborator'
            @form = @activity.evaluation_session.formL
          else
            @form = @activity.evaluation_session.formP
          end
        end
      end

      form_content = JSON.parse @form.content
      @content = form_content['chestionar']
    else
      flash[:error] = 'Acea evaluare nu iti este disponibila, poate ai completat-o deja'
      respond_to do |format|
        format.html { redirect_to evaluate_path }
      end
    end
  end

  require 'json'

  def evaluate_activity
    @activity = EvalSessionActivity.find(params[:activity_id])

    @completed_activity = CompletedEvaluation.find_by_incognito_token_and_eval_session_activity_id(@current_user_token.token, @activity.id)

    if @activity and !@completed_activity
      if @activity.activity_type == 'Curs'
        @form = @activity.evaluation_session.form
      else
        if @activity.activity_type == 'Seminar'
          @form = @activity.evaluation_session.formS
        else
          if @activity.activity_type == 'Laborator'
            @form = @activity.evaluation_session.formL
          else
            @form = @activity.evaluation_session.formP
          end
        end
      end

      form_content = JSON.parse @form.content
      @content = form_content['chestionar']

=begin
      if request.post?
        @not_completed = false
        nc = []
        answers = {}
        @content.each_with_index do |parent, qindex|
          question = parent['intrebare']
          if question
            key = "#{ qindex + 1 }"
            if params[key] == '0' and question.count > 1
              @not_completed = true
              nc << {(qindex).to_s => 'EMPTY'}
            else
              answers[key] = params[key].nil? ? '' : params[key].strip
            end
          else
            nc << {(qindex).to_s => 'label'}
          end
        end
        logger.info nc
        now = DateTime.now.strftime('%Q').to_i - params[:tpcp].to_i

        if @not_completed == true
          flash[:error] = 'Nu ai completat toate intrebarile '
        else
          CompletedEvaluation.create(incognito_token: @current_user_token.token,
                                     eval_session_activity: @activity,
                                     content: answers.to_json,
                                     date: DateTime.now,
                                     time: now)
        end

      else

      end
=end

      if request.post?
        @not_completed = false
        nr = 0
        nc = []
        answers = {}
        @content.each do |sec|
          sec.each_with_index do |parent, qindex|

            question = parent['intrebare']
            if question
              key = "#{ nr + 1 }"
              if (params[key].nil? || params[key] == '0') and question.count > 1
                @not_completed = true
                nc << {(nr).to_s => 'EMPTY'}
              else
                answers[key] = params[key].nil? ? '' : params[key].strip
              end
              nr = nr + 1
            else
              nc << {(nr).to_s => 'label'}
            end

          end
        end

        now = DateTime.now.strftime('%Q').to_i - params[:tpcp].to_i

        if @not_completed == true
          flash[:error] = 'Nu ai completat toate intrebarile '
        else
          CompletedEvaluation.create(incognito_token: @current_user_token.token,
                                     eval_session_activity: @activity,
                                     content: answers.to_json,
                                     date: DateTime.now,
                                     time: now)

        end

      else


      end
    else
      flash[:error] = 'Acea evaluare nu iti este disponibila, poate ai completat-o deja'

    end

    #get_courses_for_cohort
  end


  def view_evaluation

  end

end
