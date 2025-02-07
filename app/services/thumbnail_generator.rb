class ThumbnailGenerator
  def initialize(video, video_path)
    @video = video
    @video_path = video_path
  end

  def generate
    thumbnail_path = VideoTempfileHelper.generate("thumbnail", ".jpg")

    movie = FFMPEG::Movie.new(@video_path)
    movie.screenshot(thumbnail_path, seek_time: 5, resolution: "640x360")

    @video.thumbnail.attach(io: File.open(thumbnail_path), filename: "thumbnail.jpg")

    VideoTempfileHelper.cleanup(thumbnail_path)
  end
end
