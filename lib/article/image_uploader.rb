class Article::ImageUploader
  require 'aws-sdk-s3'

  def initialize(upload_image)
    @file =  upload_image.tempfile
    @key_name ="#{SecureRandom.hex}" 
    @s3 =Aws::S3::Resource.new(
      region:'ap-northeast-1',
      credentials:Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY']
      )
    )
  end

  def upload_image
    begin
      @s3.bucket(get_bucket_name).object(@key_name).put(body: @file)
      return true
    rescue StandardError => e
      puts "failed to upload the file:#{e}"
      return false
    end
  end

  def get_bucket
    @s3.bucket(get_bucket_name)
  end

  def get_key_name
    @key_name
  end

  private
   
   def get_bucket_name
    ENV['AWS_BUCKET_NAME']
   end
end