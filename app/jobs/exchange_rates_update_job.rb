require 'money'
require 'net/http'
require 'json'
require 'time'

class ExchangeRatesUpdateJob
  include Sidekiq::Worker

  def perform(base_currency = 'USD', status = "sidekiq_cron")
    @base_currency = base_currency
    @status = status
    Rails.logger.info("[ExchangeRatesUpdateJob] {Status = #{@status}} Start fetching rates for #{@base_currency}")
    api_key = ENV['EXCHANGE_RATE_API_KEY']
    url = URI("https://v6.exchangerate-api.com/v6/#{api_key}/latest/#{@base_currency}")

    begin
      response = Net::HTTP.get_response(url)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)

        if data['result'] == 'success'
          handle_response(data)
        else
          Rails.logger.error("[ExchangeRatesUpdateJob] API Error for #{@base_currency}: #{data['error-type'] || 'Unknown error'}")
          schedule_retry(1.hour.from_now)
        end

      else
        Rails.logger.error("[ExchangeRatesUpdateJob] HTTP Error for #{@base_currency}: #{response.code} #{response.message}")
        schedule_retry(1.hour.from_now)
      end

    rescue StandardError => e
      Rails.logger.error("[ExchangeRatesUpdateJob] Exception: #{e.message}")
      schedule_retry(1.hour.from_now)
    end
  end

  private

  def handle_response(data)
    rates = data['conversion_rates']
    next_execute_at_str = data['time_next_update_utc']

    bank = Money::Bank::VariableExchange.new

    rates.each do |currency, rate|
      next if currency == @base_currency
      next unless Money::Currency.find(currency)

      bank.add_rate(@base_currency, currency, rate)
      bank.add_rate(currency, @base_currency, 1.0 / rate)
    end

    rates.each do |cur1, rate1|
      next unless Money::Currency.find(cur1)
      rates.each do |cur2, rate2|
        next if cur1 == cur2
        next unless Money::Currency.find(cur2)
        bank.add_rate(cur1, cur2, rate2 / rate1)
      end
    end

    Money.default_bank = bank
    Rails.logger.info("[ExchangeRatesUpdateJob] Rates updated for #{@base_currency}")

    if next_execute_at_str.present?
      next_execute_at = Time.parse(next_execute_at_str).utc
      schedule_next_run(next_execute_at)
    else
      Rails.logger.warn("[ExchangeRatesUpdateJob] Next update time missing, not scheduling another job automatically")
    end
  end

  def schedule_next_run(time)
    if time > Time.now.utc
      ExchangeRatesUpdateJob.perform_at(time, @base_currency, status = "scheduled")
      Rails.logger.info("[ExchangeRatesUpdateJob] Scheduled next rates update at #{time}")
    else
      Rails.logger.warn("[ExchangeRatesUpdateJob] Next run time #{time} is in the past, not scheduling")
    end
  end

  def schedule_retry(time)
    ExchangeRatesUpdateJob.perform_at(time, @base_currency, status = "retry")
    Rails.logger.info("[ExchangeRatesUpdateJob] Scheduled retry at #{time}")
  end
end