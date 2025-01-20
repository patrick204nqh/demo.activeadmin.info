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
      transitions from: :pending, to: :processing
    end

    event :complete do
      transitions from: :processing, to: :completed
    end

    event :fail do
      transitions from: :processing, to: :failed
    end
  end

  after_commit :enqueue_processing, if: :pending?

  private

  def enqueue_processing
    return unless file.attached?

    puts "Enqueueing video processing for video #{self.id}"
    binding.pry
    ProcessVideoJob.enqueue(self.id)
  end
end
