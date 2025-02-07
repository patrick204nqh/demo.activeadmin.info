class ProcessVideoJob < ApplicationJob
  self.queue = :critical
  self.priority = 4

  def run(video_id)
    video = Video.find_by(id: video_id)
    return unless video&.uploaded?

    video_path = VideoDownloader.new(video).download
    return unless video_path

    begin
      video.process!
      puts "🎥 Processing video: #{video.id}"

      ThumbnailGenerator.new(video, video_path).generate
      VideoProcessor.new(video, video_path).process

      video.complete!
      puts "✅ Video processed: #{video.id}"
    rescue => e
      log_error("Error processing video", e)
      video.fail!
    ensure
      FileUtils.cleanup(video_path)
      finish
    end

    private

    def log_error(message, exception)
      puts "❌ #{message}: #{exception.message}"
      puts "Backtrace:\n#{exception.backtrace.join("\n")}"
    end
  end
end
