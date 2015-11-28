class UpdateDecisionAction
  def initialize(decision,value,controller)
    @decision = decision
    @value = value
    @controller = controller
  end

  def call
    @decision.transaction do
      @decision.value = @value
      @decision.save!
    end
    @controller.redirect_to @controller.decisions_path
  end
end
