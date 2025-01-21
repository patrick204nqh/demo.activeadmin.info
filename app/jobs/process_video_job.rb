class ProcessVideoJob < ApplicationJob
  self.queue = :critical

  self.priority = 4

  def run(video_id)
    video = Video.find(video_id)

    process_video(video)

    finish
  end

  private

  def process_video(video)
    puts "Video status: #{video.status}"

    output_path = Rails.root.join("tmp", "processed_#{SecureRandom.hex}.mp4")
    video_path = ActiveStorage::Blob.service.path_for(video.file.blob.key)

    movie = FFMPEG::Movie.new(video_path)

    begin
      movie.transcode(output_path.to_s, video_codec: "libx264", audio_codec: "aac")

      video.processed_file.attach(io: File.open(output_path), filename: "processed.mp4")

      video.complete!
      puts "Video processed successfully: #{output_path}"
    rescue StandardError => e
      video.fail!
      puts "Video processing failed: #{e.message}"
    ensure
      File.delete(output_path) if File.exist?(output_path)
    end
  end
end
