class Paper < ApplicationRecord
  mount_uploader :file, DocumentUploader

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id', optional: true
  belongs_to :contribution_type, optional: true
  belongs_to :academic_level, optional: true
  belongs_to :academic_area, optional: true
  belongs_to :paper_topic, optional: true
  belongs_to :paper_subtopic, optional: true
  belongs_to :used_before_option, optional: true

  belongs_to :evaluator1, class_name: 'User', foreign_key: 'evaluator1_id', optional: true
  accepts_nested_attributes_for :evaluator1, allow_destroy: true
  belongs_to :evaluator2, class_name: 'User', foreign_key: 'evaluator2_id', optional: true
  accepts_nested_attributes_for :evaluator2, allow_destroy: true
  belongs_to :evaluator3, class_name: 'User', foreign_key: 'evaluator3_id', optional: true
  accepts_nested_attributes_for :evaluator3, allow_destroy: true

  has_many :paper_users, dependent: :destroy
  has_many :users, through: :paper_users
  has_many :evaluations, dependent: :destroy

  validates :owner, :name, :academic_level_id, :academic_area_id,
            :contribution_type_id, :paper_topic_id, :paper_subtopic_id,
            :keywords, :brief, :used_before_option_id, :relevance, :file, presence: {message: ->(value, info){required_error_message}}

  def self.participates(user)
    (where(owner: user) + joins(:paper_users).where(paper_users: {user: user})).uniq
  end

  def self.evaluates(user)
    Evaluation.where(user: user).map(&:paper).uniq
  end

  def participates?(user)
    owner == user || self.users.include?(user)
  end

  def users_attributes=(users_attributes)
    users_attributes.values.each do |user_attributes|

      unless user_attributes[:_destroy] == "1"
        user = User.find_by(email: user_attributes[:email])
        if user
          unless PaperUser.exists?(user: user, paper: self)
            self.paper_users << PaperUser.new(user: user)
          end
        else
          user = User.new(user_attributes.except(:_destroy))
          user.valid?
          self.paper_users << PaperUser.new(user: user)
        end
      end

      if user_attributes[:_destroy] == "1" && user_attributes[:id]
        paper_user = PaperUser.find_by(user: User.find_by(id: user_attributes[:id]), paper: self)
        if paper_user
          paper_user.destroy
        end
      end
    end
  end

  def evaluation_by_index(index)
    case index
    when 1
      evaluation1
    when 2
      evaluation2
    when 3
      evaluation3
    end
  end

  def evaluation1
    Evaluation.find_by(user: evaluator1, paper: self)
  end

  def evaluation2
    Evaluation.find_by(user: evaluator2, paper: self)
  end

  def evaluation3
    Evaluation.find_by(user: evaluator3, paper: self)
  end

  def evaluator?(u)
    Evaluation.exists?(user: u, paper: self)
  end

  def evaluation_for(u)
    case u
    when evaluator1
      evaluation1
    when evaluator2
      evaluation2
    when evaluator3
      evaluation3
    else
      nil
    end
  end

  def overall_status
    'Sin Evaluar'
  end

  def collaborator_name
    contribution_type&.collaborator_name
  end

  def file_name
    file.identifier
  end

  def is_owner?(user)
    user == owner
  end

  def registration_date
    created_at.strftime('%d-%m-%Y')
  end

  def to_s
    name
  end

  def download
    "<a href=\"#{file.url}\">#{file_name}</a>".html_safe
  end

  def self.required_error_message
    I18n.locale == :es ? 'Requerido' : 'Required'
  end

  def evaluation_status
    r = "".tap do |result_string|
      result_string << (evaluation1 ? evaluation1.status_for_display : '<p class="evaluation-status badge badge-light d-block">Sin asignar</p>')
      result_string << (evaluation2 ? evaluation2.status_for_display : '<p class="evaluation-status badge badge-light d-block">Sin asignar</p>')
      result_string << (evaluation3 ? evaluation3.status_for_display : '<p class="evaluation-status badge badge-light d-block">Sin asignar</p>')
    end

    r.html_safe
  end

  def evaluation_status_for_evaluator(user)
    ev = evaluation_for(user)

    if ev
      r = "".tap do |result_string|
        result_string << (ev ? ev.status_for_display : '<p class="evaluation-status badge badge-light d-block">Sin evaluar</p>')
      end

      return r.html_safe
    end

    "N/A"
  end

  def evaluation_status_report
    'Sin Evaluar'
  end

  def unique_number
    "F#{created_at.strftime('%Y%m%d')}#{id.to_s.rjust(5,'0')}"
  end

  def assign_evaluators(params)
    valid = true

    if !params[:evaluator1_attributes][:email].empty?
      first = User.find_by(email: params[:evaluator1_attributes][:email])
      if first
        if self.evaluation1
          self.evaluation1.update_attribute(:user, first)
        end
        self.evaluator1 = first
      else
        self.evaluator1 = User.new(email: params[:evaluator1_attributes][:email])
        valid = false
        errors.add(:evaluator1, 'El correo del primero evaluador no existe.')
      end
    end

    if !params[:evaluator2_attributes][:email].empty?
      second = User.find_by(email: params[:evaluator2_attributes][:email])
      if second
        if self.evaluation2
          self.evaluation2.update_attribute(:user, second)
        end
        self.evaluator2 = second
      else
        self.evaluator2 = User.new(email: params[:evaluator2_attributes][:email])
        valid = false
        errors.add(:evaluator2, 'El correo del segundo evaluador no existe.')
      end
    end

    if !params[:evaluator3_attributes][:email].empty?
      third = User.find_by(email: params[:evaluator3_attributes][:email])
      if third
        if self.evaluation3
          self.evaluation3.update_attribute(:user, third)
        end
        self.evaluator3 = third
      else
        self.evaluator3 = User.new(email: params[:evaluator3_attributes][:email])
        valid = false
        errors.add(:evaluator3, 'El correo del tercer evaluador no existe.')
      end
    end

    valid
  end

  def assign_evaluator(ev)
    unless evaluator?(ev) || evaluator_count >= 3
      if !evaluator1
        self.evaluator1 = ev
      elsif !evaluator2
        self.evaluator2 = ev
      elsif !evaluator3
        self.evaluator3 = ev
      end

      save
      create_evaluations
    end
  end

  def create_evaluations
    if evaluator1 && !evaluation1
      evaluation1 = Evaluation.create_for(self, evaluator1)
      if evaluation1.valid?
        evaluation1.save
      else
        return false
      end
    end

    if evaluator2 && !evaluation2
      evaluation2 = Evaluation.create_for(self, evaluator2)
      if evaluation2.valid?
        evaluation2.save
      else
        return false
      end
    end

    if evaluator3 && !evaluation3
      evaluation3 = Evaluation.create_for(self, evaluator3)
      if evaluation3.valid?
        evaluation3.save
      else
        return false
      end
    end
  end

  def evaluator_count
    [evaluator1, evaluator2, evaluator3].compact.count
  end

  def self.assign_evaluators_among_papers
    loop do
      papers_by_evaluator_count = Paper.includes(:evaluations).select{|p| p.evaluations.count <= 2}.sort_by{|p| p.evaluations.count}

      evaluators_by_paper_count = User.includes(:evaluations).where(evaluator: true).sort_by{|u| u.evaluations.count}

      break if papers_by_evaluator_count.count <= 0

      paper_to_assign = papers_by_evaluator_count.first
      puts "Quedan: #{papers_by_evaluator_count.count}"
      puts "Procesando: #{paper_to_assign.id}"
      evaluator_index = 0
      while paper_to_assign.evaluator_count <= 2 && evaluator_index < evaluators_by_paper_count.count
        ev = evaluators_by_paper_count[evaluator_index]
        unless paper_to_assign.evaluator?(ev)
          puts "Assign #{ev.id}"
          paper_to_assign.assign_evaluator(ev)
        end

        evaluator_index += 1
      end
    end
  end

end
