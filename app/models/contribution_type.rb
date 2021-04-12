class ContributionType < ApplicationRecord
  def to_s
    if I18n.locale == :en
      english_name
    else
      name
    end
  end

  def collaborator_name
    if I18n.locale == :en
      collaborator_english_name
    else
      collaborator_spanish_name
    end
  end

  private

  def collaborator_english_name
    case name
    when 'Mesa de networking'
      'Collaborator'
    when 'Presentación de libro'
      'Commentator'
    when 'Panel'
      'Panelist'
    when 'Ponencia de innovación'
      'Coauthor'
    when 'Ponencia de investigación'
      'Coauthor'
    when 'Panel Emprendimiento Edtech'
      'Panelist'
    when 'Mesa de networking Edtech'
      'Collaborator'
    when 'Conferencia Edtech'
      'Collaborator'
    else
      'Collaborator'
    end
  end

  def collaborator_spanish_name
    case name
    when 'Mesa de networking'
      'Colaborador'
    when 'Presentación de libro'
      'Comentarista'
    when 'Panel'
      'Panelista'
    when 'Ponencia de innovación'
      'Coautor'
    when 'Ponencia de investigación'
      'Coautor'
    when 'Panel Emprendimiento Edtech'
      'Panelista'
    when 'Mesa de networking Edtech'
      'Colaborador'
    when 'Conferencia Edtech'
      'Colaborador'
    else
      'Colaborador'
    end
  end

  def english_name
    case name
    when 'Mesa de networking'
      'Networking table'
    when 'Presentación de libro'
      'Book presentation'
    when 'Panel'
      'Panel'
    when 'Ponencia de innovación'
      'Innovation paper'
    when 'Ponencia de investigación'
      'Research paper'
    when 'Panel Emprendimiento Edtech'
      'Edtech Entreprenuership Panel'
    when 'Mesa de networking Edtech'
      'Edtech Networking Table'
    when 'Conferencia Edtech'
      'Edtech Conference'
    else
      name
    end
  end
end
