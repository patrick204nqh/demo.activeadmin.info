class Video < ApplicationRecord
  include AASM

  has_one_attached :file
  has_one_attached :video_360p
  has_one_attached :video_720p
  has_one_attached :video_1080p

  validate :validate_file_format

  aasm column: :status do
    state :init, initial: true
    state :uploaded
    state :processing
    state :done
    state :failed

    event :upload do
      transitions from: :init, to: :uploaded, after: :enqueue_processing
    end

    event :process do
      transitions from: [:uploaded, :failed], to: :processing
    end

    event :complete do
      transitions from: :processing, to: :done
    end

    event :fail do
      transitions from: [:init, :uploaded, :processing], to: :failed
    end
  end

  before_destroy :purge_files
  after_commit :attempt_upload, if: -> { file.attached? && init? }

  private

  def validate_file_format
    return unless file.attached?

    unless file.content_type == "video/mp4"
      errors.add(:file, "must be an MP4 file")
    end
  end

  def attempt_upload
    upload!
  end

  def enqueue_processing
    puts "Enqueueing video processing for video #{id}"
    ProcessVideoJob.enqueue(id)
  end

  def purge_files
    files = [file, video_360p, video_720p, video_1080p]
    files.each do |attachment|
      attachment.purge if attachment.attached?
    end
  end
end
