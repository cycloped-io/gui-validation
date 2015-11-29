class PreviousDecisionAction
  attr_reader :decision

  def initialize(user,decision_id,controller)
    @user = user
    @decision_id = decision_id
    @controller = controller
  end

  def call
    decision = Decision.find(@decision_id)
    @controller.redirect_to decision.previous
  end
end
