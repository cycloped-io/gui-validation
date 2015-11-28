class RemoveDatasetAction
  def initialize(dataset,user_id,controller)
    @dataset = dataset
    @user_id = user_id
    @controller = controller
  end

  def call
    user = User.find(@user_id)
    @dataset.transaction do
      user.decisions.where(dataset: @dataset).each do |decision|
        decision.destroy
      end
      @dataset.users.delete(@user_id)
    end
    @controller.redirect_to @dataset
  end
end
