IMAGE_UPLOADER_ALLOW_IMAGE_VERSION_NAMES = %(40)
class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :upyun
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/"
  end

  def url(version_name = "")
    @url ||= super({})
    version_name = version_name.to_s
    return @url if version_name.blank?
    if not version_name.in?(IMAGE_UPLOADER_ALLOW_IMAGE_VERSION_NAMES)
      # To protected version name using, when it not defined, this will be give an error message in development environment
      raise "ImageUploader version_name:#{version_name} not allow."
    end
    [@url,version_name].join("!") # thumb split with "!"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if super.present? && original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path)).slice(0, 12)
      "#{@name}.#{file.extension}".downcase
    end
  end
  
  # def filename
  #   if super.present?
  #     filename = SecureRandom.uuid.gsub("-","")
  #     Rails.logger.debug("(BaseUploader.filename) #{filename}")
  #     "#{filename}.#{file.extension.downcase}"
  #   end
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
