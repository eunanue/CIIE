class DocumentUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "#{Rails.env.production? ? 'prod' : 'dev'}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def fog_public
    false
  end

  def extension_whitelist
    %(docx)
  end

  def fog_authenticated_url_expiration
    30.minutes
  end
end
