Rails.application.configure do
  config.lograge.enabled = true

  # add time to lograge
  config.lograge.custom_options = lambda do |event|
    {time: Time.now}
  end

  config.lograge.ignore_actions = ["UpController#show"]
end
