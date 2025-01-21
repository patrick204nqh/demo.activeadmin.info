class Video < ApplicationRecord
  include AASM

  has_one_attached :file
  has_one_attached :processed_file

  aasm column: :status do
    state :pending, initial: true
    state :processing
    state :completed
    state :failed

    event :process do
      transitions from: :pending, to: :processing, after: :enqueue_processing
    end

    event :complete do
      transitions from: :processing, to: :completed
    end

    event :fail do
      transitions from: :processing, to: :failed
    end
  end

  after_commit :start_processing, on: :create, if: -> { pending? && file.attached? }

  private

  def start_processing
    process!
  end

  def enqueue_processing
    puts "Enqueueing video processing for video #{id}"
    ProcessVideoJob.enqueue(id)
  rescue StandardError => e
    Rails.logger.error("Failed to enqueue processing for video #{id}: #{e.message}")
    raise e
  end
end
