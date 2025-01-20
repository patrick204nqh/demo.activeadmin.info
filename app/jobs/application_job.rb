class ApplicationJob < Que::Job
  def run
    # destroy / finish
    raise NotImplementedError
  end

  def log_level(elapsed)
    if elapsed > 60
      :warn
    elsif elapsed > 30
      :info
    else
      false
    end
  end
end
