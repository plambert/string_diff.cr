module Colorize
  def self.with(enabled : Bool? = nil, &)
    if enabled.nil?
      yield
    else
      save_enabled = Colorize.enabled
      begin
        Colorize.enabled = enabled
        yield
      ensure
        Colorize.enabled = save_enabled
      end
    end
  end
end
