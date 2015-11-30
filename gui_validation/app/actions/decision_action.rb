class DecisionAction
  protected
  def next_decision
    if @user.nil?
      @controller.redirect_to @controller.done_decisions_path
      return
    end
    dataset = @user.datasets.find do |dataset|
      @user.progress(dataset) < 100
    end
    if dataset.nil?
      @controller.redirect_to @controller.done_decisions_path
      return
    end
    dataset.next_decision_for(@user)
  end
end
