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

    true
  end

  def fetch_video_path(video)
    return nil unless video.file.attached?

    begin
      url = video.file.url(expires_in: 600) # Generate a signed URL

      output_path = Rails.root.join("tmp", "video_#{video.id}.mp4").to_s
      download_video(url, output_path)
    rescue => e
      puts "⚠️ Error fetching video path: #{e.message}"
      nil
    end
  end

  def download_video(url, output_path)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      File.open(output_path, "wb") { |file| file.write(response.body) }
      puts "✅ Video saved to: #{output_path}"
      return output_path
    else
      puts "❌ Error downloading video: #{response.code} #{response.message}"
      return nil
    end
  end

  def process_video(video)
    puts "🎬 Processing video ID: #{video.id}, Status: #{video.status}"

    video_path = fetch_video_path(video)
    return unless video_path && File.exist?(video_path)

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
      cleanup_temp_file(video_path)
      cleanup_temp_file(processed_path)
    end
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
      watermark_filter: { position: "RT", padding_x: 20, padding_y: 20 },
      custom: ["-preset", "fast", "-crf", "28"]
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
