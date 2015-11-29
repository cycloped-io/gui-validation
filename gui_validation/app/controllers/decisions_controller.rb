class DecisionsController < ApplicationController
  def index
    action = IndexDecisionAction.new(current_user,self).call
    @decision = action.decision
  end

  def next
    NextDecisionAction.new(current_user,params[:id],self).call
  end

  def previous
    PreviousDecisionAction.new(current_user,params[:id],self).call
  end

  def show
    @decision = Decision.find(params[:id])
    render :index
  end

  def update
    @decision = Decision.find(params[:id])
    UpdateDecisionAction.new(@decision,params[:value],self).call
  end

  def done
  end
end
