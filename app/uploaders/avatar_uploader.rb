class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # 包括RMagick或MiniMagick支持：
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # 选择用于此上传者的存储类型：
  storage :file   # 文件
  # storage :fog  # 云端

  # Override the directory where uploaded files will be stored.
  # 覆盖上传的文件将被存储的目录。
  # This is a sensible default for uploaders that are meant to be mounted:
  # 对于要挂载的上传者来说，这是一个明智的默认：
  def store_dir
   # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
   "uploads/#{model.tagPath}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # 如果尚未上传文件，请提供默认网址：
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
      # 对于Rails 3.1+资产管道兼容性：
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # 在上传文件时处理文件：
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # 创建不同版本的上传文件：
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # 添加允许上传的扩展名的白名单。
  # For images you might use something like this:
  # 对于图像，您可能会使用这样的东西：
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # 覆盖上传文件的文件名：
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # 避免在这里使用model.id或version_name，请参阅uploader / store.rb了解详细信息。
  # def filename
  #   "something.jpg" if original_filename
  # end

end
