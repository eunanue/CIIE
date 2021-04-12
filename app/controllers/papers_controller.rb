class PapersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    load_papers
    authorize Paper
  end

  def new
    build_paper
    authorize @paper
  end

  def create
    build_paper
    authorize @paper

    @paper.owner = current_user
    @paper.generation = '2021'

    if @paper.save
      @paper.users.each do |user|
        UserMailer.paper_invitation_mail(@paper, user).deliver_later
      end

      UserMailer.paper_invitation_mail(@paper, @paper.owner).deliver_later

      redirect_to({action: 'edit', id: @paper.id}, notice: I18n.t('paper.success_edited')) and return
    else
      flash.now[:alert] = I18n.t('paper.error_edited')
    end

    render 'new'
  end

  def show
    load_paper
    authorize @paper

    redirect_to({action: 'edit', id: @paper.id})
  end

  def edit
    load_paper
    authorize @paper
  end

  def update
    load_paper
    authorize @paper

    if @paper.update(paper_params)
      @paper.users.each do |user|
        if user.needs_invitation?
          UserMailer.paper_invitation_mail(@paper, user).deliver_later
        end
      end

      flash.now[:success] = I18n.t('paper.success_edited')
    else
      flash.now[:alert] = I18n.t('paper.error_edited')
    end

    render 'edit'
  end

  def destroy
    load_paper
    authorize @paper

    @paper.destroy

    render json: {message: 'La ponencia ha sido eliminada'}
  end

  def report
    authorize Paper

    respond_to do |format|
      format.xlsx
    end
  end

  private

  def load_papers
    if (params.key? :generation) && %w[2020 2021].include?(params[:generation])
      @papers ||= paper_scope.filter{|p| p.generation == params[:generation]}
      @generation = params[:generation]
    else
      @papers ||= paper_scope.filter{|p| p.generation == '2021'}
      @generation = '2021'
    end

    @papers ||= paper_scope
  end

  def load_paper
    @paper ||= Paper.find_by(id: params[:id])
  end

  def build_paper
    @paper ||= Paper.new
    @paper.attributes = paper_params
  end

  def paper_params
    paper_params = params[:paper]
    paper_params ? paper_params.permit(:id,
                                       :generation,
                                       :name,
                                       :contribution_type_id,
                                       :academic_level_id,
                                       :academic_level_other,
                                       :academic_area_id,
                                       :academic_area_other,
                                       :paper_topic_id,
                                       :paper_subtopic_id,
                                       :subtopic_other,
                                       :used_before_option_id,
                                       :keywords,
                                       :brief,
                                       :used_before,
                                       :relevance,
                                       :file,
                                       users_attributes: [:id,
                                                          :code,
                                                          :email,
                                                          :names,
                                                          :last_names,
                                                          :phone,
                                                          :country_id,
                                                          :state_id,
                                                          :institution_name,
                                                          :institution_type_id,
                                                          :institution_privacy_id,
                                                          :institution_id,
                                                          :spv,
                                                          :_destroy]) : {}
  end

  def paper_scope
    if current_user.admin?
      Paper.all
    else
      Paper.where(generation: '2021').participates(current_user) +
        Paper.where(generation: '2021').evaluates(current_user)
    end
  end
end
