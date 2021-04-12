class InstitutionPrivacy < ApplicationRecord
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
    when 'Privada'
      'Private'
    when 'Pública'
      'Public'
    else
      name
    end
  end
end
