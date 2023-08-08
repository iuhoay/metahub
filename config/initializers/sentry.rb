Sentry.init do |config|
  config.dsn = "https://2a5de6cdafc34432b6094c86423c3608@o4504756520747008.ingest.sentry.io/4504756524548096"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  # config.traces_sample_rate = 1.0 if Rails.env.production?
  # or
  # config.traces_sampler = lambda do |context|
  #   true
  # end
end
