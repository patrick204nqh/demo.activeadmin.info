class VideoTempfileHelper
  def self.generate(label, ext = ".mp4")
    Tempfile.new([label, ext]).tap(&:close).path
  end

  def self.cleanup(file_path)
    File.delete(file_path) if File.exist?(file_path)
  rescue => e
    puts "⚠️ Error cleaning up tempfile: #{e.message}"
  end
end
