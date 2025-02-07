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
    puts "❌ Error downloading video: #{e.message}"
    puts "Backtrace:\n#{e.backtrace.join("\n")}"
    @video.log_error("Error downloading video", e)
    nil
  end
end
