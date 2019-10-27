class Article::DeleteImage
  require 'aws-sdk-s3'
  def initialize(image_url)
    puts image_url
    @delete_image = image_url.split('amazonaws.com/')[1]
    Aws.config.update({
    region: 'ap-northeast-1',
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
    })
    @s3 = Aws::S3::Resource.new.bucket(get_bucket_name)
  end

  def delete
    begin
      @s3.object(@delete_image).delete
      return true
    rescue => e
        # Do nothing. Leave the now defunct file sitting in the bucket.
      return true
    end
  end


  private

  def get_bucket_name
    ENV['AWS_BUCKET_NAME']
  end
end
