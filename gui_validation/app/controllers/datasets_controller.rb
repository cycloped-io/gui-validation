class DatasetsController < ApplicationController
  before_action :user_required

  def index
    @datasets = Dataset.all
  end

  def show
    @dataset = Dataset.find(params[:id])
  end

  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.new(dataset_params)
    CreateDatasetAction.new(@dataset,self).call
  end

  def destroy
    dataset = Dataset.find(params[:id])
    dataset.destroy
    redirect_to datasets_path
  end

  def assign
    @dataset = Dataset.find(params[:id])
    AssignDatasetAction.new(@dataset,params[:dataset][:user_id],self).call
  end

  def remove
    @dataset = Dataset.find(params[:id])
    RemoveDatasetAction.new(@dataset,params[:user_id],self).call
  end

  def split_form
    @dataset = Dataset.find(params[:id])
  end

  def split
    @dataset = Dataset.find(params[:id])
    SplitDatasetAction.new(@dataset,split_params[:partials].to_i,self).call
    redirect_to datasets_path
  end

  private
  def dataset_params
    params.require(:dataset).permit(:name,:relation,:file,:language)
  end

  def split_params
    params.require(:dataset).permit(:partials)
  end
end
