class DecisionAction
  protected
  def next_decision
    dataset = @user.datasets.find do |dataset|
      @user.progress(dataset) < 100
    end
    if dataset.nil?
      @controller.redirect_to :done
      return
    end
    dataset.next_decision_for(@user)
  end
end
