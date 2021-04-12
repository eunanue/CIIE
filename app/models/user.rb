class User < ApplicationRecord
  attr_accessor :spv #skip-password-validation

  enum role: [:admin, :professor]

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  belongs_to :country, optional: true
  belongs_to :state, optional: true
  belongs_to :institution, optional: true
  belongs_to :institution_privacy, optional: true
  belongs_to :institution_type, optional: true

  has_many :paper_users
  has_many :papers, through: :paper_users
  has_many :paper_topics
  has_many :evaluations

  validates :email, :names, :last_names, :institution_id, presence: {message: 'Requerido'}
  validate :extra_institution_fields, on: :create
  validate :code_for_tec_community, on: :create

  def evaluator?
    professor? && Evaluation.exists?(user: self)
  end

  def evaluations_count
    Evaluation.where(user: self).count
  end

  def full_name
    "#{names} #{last_names}"
  end

  def needs_invitation?
    encrypted_password.empty?
  end

  def assign_temporary_password
    temporary_password = (0...8).map { (65 + rand(26)).chr }.join.downcase

    self.password = self.password_confirmation = temporary_password
    self.save

    temporary_password
  end

  def must_complete_profile?
    self.invalid?
  end

  def to_s
    full_name
  end

  def self.create_evaluator!(names:, last_names:, email:, institution_name:, country_name:)
    evaluator = User.new(names: names, last_names: last_names, email: email)

    evaluator_institution = Institution.find_by(name: institution_name)
    if evaluator_institution
      evaluator.institution = evaluator_institution
    else
      evaluator.institution = Institution.find_by(name: 'Otra')
      evaluator.institution_name = institution_name
    end

    evaluator_country = Country.find_by(name: country_name)
    if evaluator_country
      evaluator.country = evaluator_country
    end

    temporary_password = (0...8).map { (65 + rand(26)).chr }.join.downcase
    evaluator.password = temporary_password
    evaluator.password_confirmation = temporary_password

    evaluator.evaluator = true
    evaluator.spv = true

    evaluator.save!

    evaluator
  end

  protected

  def code_for_tec_community
    if institution && (institution.name == 'Tecnológico de Monterrey' || institution.name == 'Tecmilenio')
      if code.to_s.empty?
        errors.add(:code, 'Requerido')
      end
    end
  end

  def extra_institution_fields
    if spv
      return
    end

    if institution && (institution.name == 'Otra' || institution.name == 'Escuelas vinculadas')
      if institution_name.to_s.empty?
        errors.add(:institution_name, 'Requerido')
      end

      unless institution_privacy
        errors.add(:institution_privacy_id, 'Requerido')
      end

      unless institution_type
        errors.add(:institution_type_id, 'Requerido')
      end
    end
  end

  def password_required?
    return false if spv
    super
  end
end
