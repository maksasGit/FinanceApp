Sidekiq::Cron::Job.create(
  name: "ScheduledTransactionJob every 1 minute",
  cron: "*/1 * * * *",
  class: "ScheduledTransactionJob"
)
