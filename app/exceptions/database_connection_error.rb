class DatabaseConnectionError < StandardError
  def initialize(message = "Connection error")
    super(message)
  end
end
