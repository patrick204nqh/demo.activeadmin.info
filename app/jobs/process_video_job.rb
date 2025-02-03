class ProcessVideoJob < ApplicationJob
  self.queue = :critical
  self.priority = 4

  def run(video_id)
    video = Video.find_by(id: video_id)
    return unless valid_video?(video)

    process_video(video)

    finish
  end

  private

  def valid_video?(video)
    return false unless video&.file.attached?

    video_path = fetch_video_path(video)
    return false unless video_path && File.exist?(video_path)

    true
  end

  def process_video(video)
    puts "🎬 Processing video ID: #{video.id}, Status: #{video.status}"

    video_path = fetch_video_path(video)
    processed_path = generate_processed_path

    begin
      movie = FFMPEG::Movie.new(video_path)
      transcode_video(movie, processed_path)
      attach_processed_video(video, processed_path)

      video.complete!
      puts "✅ Video processing completed: #{processed_path}"
    rescue => e
      video.fail!
      puts "❌ Processing failed: #{e.message}"
      puts e.backtrace.join("\n")
    ensure
      cleanup_temp_file(processed_path)
    end
  end

  def fetch_video_path(video)
    ActiveStorage::Blob.service.path_for(video.file.blob.key)
  rescue => e
    puts "⚠️ Error fetching video path: #{e.message}"
    nil
  end

  def generate_processed_path
    Rails.root.join("tmp", "processed_#{SecureRandom.hex}.mp4").to_s
  end

  def transcode_video(movie, output_path)
    options = {
      resolution: "1280x720", # 720p
      video_codec: "libx264",
      audio_codec: "aac",
      watermark: Rails.root.join("app/assets/images/watermark.png").to_s,
      watermark_filter: { position: "RT", padding_x: 10, padding_y: 10 },
      custom: ["-preset", "slow", "-crf", "23", "-b:v", "1000k", "-maxrate", "1200k", "-bufsize", "2000k"]
    }

    movie.transcode(output_path, options)
  end

  def attach_processed_video(video, processed_path)
    return unless File.exist?(processed_path)

    video.processed_file.attach(
      io: File.open(processed_path),
      filename: File.basename(processed_path),
      content_type: "video/mp4"
    )
  end

  def cleanup_temp_file(file_path)
    File.delete(file_path) if File.exist?(file_path)
  end
end
