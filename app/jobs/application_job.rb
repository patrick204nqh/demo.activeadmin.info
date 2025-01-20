class ApplicationJob < Que::Job
  def run
    # destroy / finish
    raise NotImplementedError
  end
end
