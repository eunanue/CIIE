class InstitutionType < ApplicationRecord
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
    when 'Institución educativa'
      'Educational Institution'
    when 'Empresa'
      'Business'
    when 'Organización de la sociedad civil'
      'NGO'
    when 'Gubernamental'
      'Governmental'
    else
      name
    end
  end
end
