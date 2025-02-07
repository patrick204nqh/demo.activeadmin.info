class ProcessVideoJob < ApplicationJob
  self.queue = :critical
  self.priority = 4
  self.retry_interval = 5
  self.maximum_retry_count = 3

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

      FileUtils.cleanup(video_path)
      puts "🧹 Cleaned up video: #{video.id}"

      finish
      puts "🏁 Finished processing video: #{video.id}"
    rescue => e
      puts "❌ Error processing video: #{e.message}"
      puts "Backtrace:\n#{e.backtrace.join("\n")}"
      video.log_error("Error processing video", e)
      video.fail!
    end
  end
end
