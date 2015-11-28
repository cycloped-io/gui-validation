class UpdateDecisionAction
  def initialize(decision,controller)
    @decision = decision
    @controller = controller
  end

  def call
    @decision.save
    @controller.redirect_to @controller.decisions_path
  end
end
