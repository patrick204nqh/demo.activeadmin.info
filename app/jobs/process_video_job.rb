class ProcessVideoJob < ApplicationJob
  self.queue = :critical
  self.priority = 4
  self.retry_interval = 5
  self.maximum_retry_count = 3

  def run(video_id)
    @video = find_video(video_id)
    return unless @video

    video_path = download_video
    return unless video_path

    process_video(video_path)
  ensure
    cleanup_temp_files(video_path)
  end

  private

  def find_video(video_id)
    video = Video.find_by(id: video_id)
    return video if video&.uploaded?

    puts "⚠️ Skipping video #{video_id}: Not found or not uploaded"
    nil
  end

  def download_video
    video_path = VideoDownloader.new(@video).download
    unless video_path
      puts "⚠️ Failed to download video #{@video.id}"
    end
    video_path
  end

  def process_video(video_path)
    @video.process!
    puts "🎥 Processing video: #{@video.id}"

    ThumbnailGenerator.new(@video, video_path).generate
    VideoProcessor.new(@video, video_path).process

    @video.complete!
    puts "✅ Video processed: #{@video.id}"
  end

  def cleanup_temp_files(video_path)
    return unless video_path

    VideoTempfileHelper.cleanup(video_path)
    puts "🧹 Cleaned up video: #{@video.id}"
  end

  def handle_error(error)
    return unless que_target

    max_retries = resolve_que_setting(:maximum_retry_count)

    if max_retries && error_count > max_retries
      puts "🚫 Max retries exceeded for video #{@video&.id || 'unknown'}"
      @video&.log_error("Error processing video", error)
      @video&.fail!
      expire
    else
      retry_in_default_interval
    end
  end
end
