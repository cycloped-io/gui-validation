class AssignDatasetAction
  def initialize(dataset,user_id,controller)
    @dataset = dataset
    @controller = controller
    @user_id = user_id
  end

  def call
    @dataset.transaction do
      @dataset.users << User.find(@user_id)
      @dataset.statements.each.with_index do |statement,index|
        # The user might have some decisions already made before split
        unless @dataset.decisions.where(user_id: @user_id).first
          Decision.create!(user_id: @user_id, statement: statement, dataset: @dataset, position: index)
        end
      end
    end
    @controller.redirect_to @dataset
  end
end
