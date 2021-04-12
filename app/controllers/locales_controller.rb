class LocalesController < ApplicationController
  def toggle
    if I18n.locale == :es
      I18n.locale == :en
      current_user.update_attribute(:locale, 'en') if current_user
    else
      I18n.locale = :es
      current_user.update_attribute(:locale, 'es') if current_user
    end

    redirect_back(fallback_location: root_path)
  end
end
