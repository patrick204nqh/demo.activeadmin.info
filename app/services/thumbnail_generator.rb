class ThumbnailGenerator
  def initialize(video, video_path)
    @video = video
    @video_path = video_path
  end

  def generate
    thumbnail_path = VideoTempfileHelper.generate("thumbnail", ".jpg")

    movie = FFMPEG::Movie.new(@video_path)
    movie.screenshot(thumbnail_path, seek_time: 5, resolution: "640x360")

    @video.thumbnail.attach(io: File.open(thumbnail_path), filename: "thumbnail.jpg")

    VideoTempfileHelper.cleanup(thumbnail_path)
  rescue StandardError => e
    log_error("Error generating thumbnail", e)
  end

  private

  def log_error(message, exception)
    puts "❌ #{message}: #{exception.message}"
    puts "Backtrace:\n#{exception.backtrace.join("\n")}"
  end
end
