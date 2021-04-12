class PaperTopic < ApplicationRecord
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
    when 'Tendencias Educativas'
      'Educational Trends'
    when 'Formación a lo Largo de la Vida'
      'Lifelong Learning'
    when 'Gestión de la Innovación Educativa'
      'Educational Innovation Management'
    when 'Innovación Académica en Salud'
      'Academic Health Innovation'
    when 'Tecnologías para la Educación'
      'Educational Technologies'
    when 'Emprendimiento Edtech'
      'Edtech Entrepreneurship'
    else
      name
    end
  end
end
