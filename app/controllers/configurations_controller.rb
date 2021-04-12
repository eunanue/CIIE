class ConfigurationsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def edit
    authorize :configuration, :edit?

    unless @paper
      @paper = Paper.find_by(id: params[:id])
      init_assignments
    end
  end

  def update
    authorize :configuration, :update?

    @paper = Paper.find_by(id: assignment_params[:id])

    if @paper.assign_evaluators(assignment_params) && @paper.save
      @paper.create_evaluations
      redirect_to({controller: 'papers', action: 'index'}, notice: 'La asignación de evaluadores fue exitosa.') and return
    end

    init_assignments
    render 'edit'
  end

  private

  def init_assignments
    @paper.evaluator1 = User.new unless @paper.evaluator1
    @paper.evaluator2 = User.new unless @paper.evaluator2
    @paper.evaluator3 = User.new unless @paper.evaluator3
  end

  def assignment_params
    assignment_params = params[:paper]
    assignment_params ? assignment_params.permit(:id,
                                                 {evaluator1_attributes: [:email]},
                                                 {evaluator2_attributes: [:email]},
                                                 {evaluator3_attributes: [:email]}) : {}
  end
end
