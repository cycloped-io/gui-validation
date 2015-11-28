class DecisionsController < ApplicationController
  def index
    action = IndexDatasetAction.new(current_user,self).call
    @decision = action.decision
  end

  def next
  end

  def previous
  end

  def show
  end

  def update
    @decision = Decision.find(params[:id])
    UpdateDecisionAction.new(@decision,decision_params[:value],self).call
  end

  def done
  end

  private
  def decision_params
    params.require(:decision).permit(:value)
  end
end
