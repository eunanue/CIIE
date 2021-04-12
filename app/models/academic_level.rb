class AcademicLevel < ApplicationRecord
  def to_s
    if I18n.locale == :en
      english_name
    else
      name
    end
  end

  private

  def english_name
    case name
    when 'Educación básica'
      'K-12'
    when 'Preparatoria (Media superior)'
      'High school'
    when 'Profesional (Superior)'
      'Undergraduate'
    when 'Posgrado'
      'Graduate'
    when 'Extensión'
      'Lifelong Learning'
    when 'Otro'
      'Other'
    else
      name
    end
  end
end
