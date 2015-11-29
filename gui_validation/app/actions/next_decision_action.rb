class NextDecisionAction < DecisionAction
  def initialize(user,decision_id,controller)
    @user = user
    @decision_id = decision_id
    @controller = controller
  end

  def call
    decision = Decision.find(@decision_id)
    @controller.redirect_to decision.next
  end
end
