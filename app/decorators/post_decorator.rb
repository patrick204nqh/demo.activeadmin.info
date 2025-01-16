class PostDecorator < Draper::Decorator
  delegate_all

  def display_image(size: :small)
    if object.image.attached?
      dimensions = dimensions_for(size)
      h.image_tag object.image.variant(resize_to_limit: dimensions).processed
    else
      default_image_tag(size)
    end
  end

  private

  def default_image_tag(size)
    dimensions = dimensions_for(size)
    h.image_tag ActionController::Base.helpers.asset_path('default_image.jpg'), width: dimensions[0], height: dimensions[1]
  end

  def dimensions_for(size)
    case size
    when :small
      [100, 100]
    when :medium
      [200, 200]
    end
  end
end
