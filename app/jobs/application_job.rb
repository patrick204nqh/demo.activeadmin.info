class ApplicationJob < Que::Job
  self.run_at = proc { 1.seconds.from_now }

  self.priority = 10

  def run
    # destroy / finish
    raise NotImplementedError
  end
end
