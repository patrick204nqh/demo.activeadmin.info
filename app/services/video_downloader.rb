class VideoDownloader
  def initialize(video)
    @video = video
  end

  def download
    return unless @video.file.attached?

    temp_path = VideoTempfileHelper.generate("original", ".mp4")

    File.open(temp_path, "wb") do |f|
      f.write(@video.file.download)
    end

    temp_path
  rescue StandardError => e
    log_error("Error downloading video", e)
    nil
  end

  private

  def log_error(message, exception)
    puts "❌ #{message}: #{exception.message}"
    puts "Backtrace:\n#{exception.backtrace.join("\n")}"
  end
end
