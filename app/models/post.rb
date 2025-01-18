class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :category
  has_one_attached :image

  validates :category, presence: true
  validate :validate_image_format
  
  private

  def validate_image_format
    return unless image.attached?

    acceptable_types = ["image/jpeg", "image/png", "image/gif"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG, PNG, or GIF")
    end
  end
end