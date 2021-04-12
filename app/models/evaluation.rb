class Evaluation < ApplicationRecord
  belongs_to :paper
  belongs_to :user
  has_many :marks, dependent: :delete_all

  accepts_nested_attributes_for :marks, allow_destroy: true

  def self.create_for(paper, user)
    evaluation = self.new

    evaluation.tap do |ev|
      ev.paper = paper
      ev.user = user

      ecs = EvaluationCriterium.where(contribution_type: paper.contribution_type)
      ecs.each do |ec|
        ev.marks << Mark.new(evaluation_criterium: ec)
      end
    end
  end

  def is_owner?(u)
    u == self.user
  end

  def incomplete?
    marks.map(&:score).include?(nil) || veredict.nil?
  end

  def accepted?
    veredict
  end

  def rejected?
    !veredict
  end

  def total_points
    marks.map{|m| m.score || 0}.reduce(:+)
  end

  def veredict_for_report
    if incomplete?
      "Incompleta"
    elsif accepted?
      "Aceptada"
    else
      "Rechazada"
    end
  end

  def status_for_display
    if incomplete?
      "<a href=\"/evaluations/#{id}/edit\"><p class=\"evaluation-status badge badge-warning d-block\">Incompleta</p></a>"
    elsif accepted?
      "<a href=\"/evaluations/#{id}/edit\"><p class=\"evaluation-status badge badge-success d-block\">Aceptada</p></a>"
    else
      "<a href=\"/evaluations/#{id}/edit\"><p class=\"evaluation-status badge badge-danger d-block\">Rechazada</p></a>"
    end
  end
end
