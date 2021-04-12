class EvaluationsController < ApplicationController

  def index
  end

  def edit
    load_evaluation
    authorize @evaluation
  end

  def update
    load_evaluation
    authorize @evaluation

    if @evaluation.update(evaluation_params)
      flash.now[:success] = 'La evaluación se ha guardado exitosamente'
    else
      flash.now[:alert] = 'La evaluación contiene errores. Favor de revisar los datos provistos'
    end

    render 'edit'
  end

  def report
    authorize Evaluation

    respond_to do |format|
      format.xlsx
    end
  end

  private

  def load_evaluations
    @papers ||= paper_scope
  end

  def load_evaluation
    @evaluation ||= Evaluation.find_by(id: params[:id])
  end

  def build_evaluation
    @evaluation ||= Evaluation.new
    @evaluation.attributes = evaluation_params
  end

  def evaluation_params
    evaluation_params = params[:evaluation]
    evaluation_params ? evaluation_params.permit(:id,
                                                 :veredict,
                                                 :feedback,
                                                 marks_attributes: [:id,
                                                                    :score,
                                                                    :_destroy]) : {}
  end
end
