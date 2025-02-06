class ProcessVideoJob < ApplicationJob
  self.queue = :critical
  self.priority = 4

  def run(video_id)
    video = Video.find_by(id: video_id)
    return unless video&.uploaded?

    video_path = download_video(video.file)
    return unless video_path

    begin
      video.process!
      puts "🎥 Processing video: #{video.id}"

      process_video(video_path, video)

      video.complete!
      puts "✅ Video processed: #{video.id}"
    rescue => e
      puts "❌ Error processing video: #{e.message}"
      puts "Backtrace:\n#{e.backtrace.join("\n")}"
      video.fail!
    ensure
      cleanup_tempfile(video_path)
      finish
    end
  end

  private

  def download_video(file)
    return unless file.attached?

    temp_path = generate_tempfile("original", ".mp4")

    File.open(temp_path, "wb") do |f|
      f.write(file.download)
    end

    temp_path
  rescue StandardError => e
    puts "❌ Error downloading video: #{e.message}"
    puts "Backtrace:\n#{e.backtrace.join("\n")}"
    nil
  end

  def process_video(input_path, video)
    resolutions = {
      "360p" => { width: 640, height: 360 },
      "720p" => { width: 1280, height: 720 },
      "1080p" => { width: 1920, height: 1080 }
    }

    resolutions.each do |label, size|
      output_path = generate_tempfile(label)

      transcoder = FFMPEG::Movie.new(input_path)
      transcoder.transcode(output_path, video_options(size))

      attach_video(video, output_path, label)
      cleanup_tempfile(output_path)
    end
  end

  def video_options(size)
    {
      video_codec: "libx264",
      resolution: "#{size[:width]}x#{size[:height]}",
      audio_codec: "aac",
      custom: ["-preset", "fast", "-crf", "28"]
    }
  end

  def attach_video(video, file_path, label)
    video.send("video_#{label}").attach(io: File.open(file_path), filename: "#{label}.mp4")
  end

  def generate_tempfile(label, ext = ".mp4")
    Tempfile.new([label, ext]).tap(&:close).path
  end

  def cleanup_tempfile(file_path)
    File.delete(file_path) if File.exist?(file_path)
  rescue => e
    puts "⚠️ Error cleaning up tempfile: #{e.message}"
  end
end
