class UsedBeforeOption < ApplicationRecord
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
    when 'Es la primera vez'
      'First time'
    when 'Ya ha sido presentado'
      'Presented before'
    when 'Continuación de un previo'
      'Continuation from previous work'
    else
      name
    end
  end
end
