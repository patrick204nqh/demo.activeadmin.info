class VideoProcessor
  RESOLUTIONS = {
    "360p" => { width: 640, height: 360 },
    "720p" => { width: 1280, height: 720 },
    "1080p" => { width: 1920, height: 1080 }
  }.freeze

  def initialize(video, video_path)
    @video = video
    @video_path = video_path
  end

  def process
    RESOLUTIONS.each do |label, size|
      output_path = VideoTempfileHelper.generate(label)

      transcoder = FFMPEG::Movie.new(@video_path)
      transcoder.transcode(output_path, video_options(size))

      @video.send("video_#{label}").attach(io: File.open(output_path), filename: "#{label}.mp4")

      VideoTempfileHelper.cleanup(output_path)
    end
  end

  private

  def video_options(size)
    {
      video_codec: "libx264",
      resolution: "#{size[:width]}x#{size[:height]}",
      audio_codec: "aac",
      custom: ["-preset", "fast", "-crf", "28"]
    }
  end
end
