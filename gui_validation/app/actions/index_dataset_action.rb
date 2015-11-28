class IndexDatasetAction
  attr_reader :decision

  def initialize(user,controller)
    @controller = controller
    @user = user
  end

  def call
    dataset = @user.datasets.find do |dataset|
      @user.progress(dataset) < 100
    end
    if dataset.nil?
      @controller.redirect_to :done
      return
    end
    @decision = dataset.next_decision_for(@user)
    self
  end
end
