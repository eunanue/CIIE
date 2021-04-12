class AcademicArea < ApplicationRecord
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
    when 'Agricultura y Alimentos'
      'Agriculture and Food'
    when 'Arquitectura'
      'Architecture'
    when 'Ciencias Básicas'
      'Basic Science'
    when 'Ciencias Sociales y Humanidades'
      'Social Science and Humanities'
    when 'Comunicación y Periodismo'
      'Comunication and Journalism'
    when 'Derecho'
      'Law'
    when 'Diseño y Arte aplicado'
      'Design and Applied Art'
    when 'Educación'
      'Education'
    when 'Gobierno'
      'Government'
    when 'Ingeniería'
      'Engineering'
    when 'Negocios y Administración'
      'Business and Administration'
    when 'Salud'
      'Health'
    when 'Tecnologías de información y Electrónica'
      'Information Technology and Electronics'
    when 'Otro'
      'Other'
    else
      name
    end
  end
end
