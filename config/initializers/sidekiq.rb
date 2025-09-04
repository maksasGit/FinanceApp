require "sidekiq"

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq::Cron::Job.create(
      name: "ScheduledTransactionJob every 1 minute",
      cron: "*/5 * * * *",
      class: "ScheduledTransactionJob"
    )
    Sidekiq::Cron::Job.create(
      name: "ExchangeRatesUpdateJob every day at 12 AM",
      cron: "0 12 * * *",
      class: "ExchangeRatesUpdateJob"
    ) # in case no running or scheduled jobs of this class are in queue
  end
end
