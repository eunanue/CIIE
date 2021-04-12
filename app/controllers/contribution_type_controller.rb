class ContributionTypeController < ApplicationController
  def get_url
    if params[:contribution_type_id].nil? || params[:contribution_type_id].empty?
      render json: {error: true}
    else
      @contribution_type = ContributionType.find(params[:contribution_type_id])

      if @contribution_type
        render json: @contribution_type
      else
        render json: {error: true}
      end
    end
  end
end
