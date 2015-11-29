class IndexDecisionAction < DecisionAction
  attr_reader :decision

  def initialize(user,controller)
    @controller = controller
    @user = user
  end

  def call
    @decision = next_decision
    self
  end
end
