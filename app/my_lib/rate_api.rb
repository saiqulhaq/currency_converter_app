# frozen_string_literal: true

# Responsible to fetch data from currencylayer.com
class RateApi
  API_KEY = Rails.application.credentials.currency_layer_api_key
  DEFAULT_SOURCE = MoneyRails.default_currency.iso_code

  def initialize
    @api_response = {}
  end

  # def live(source = DEFAULT_SOURCE)
  #   'foo'
  # end

  def historical(date, source = DEFAULT_SOURCE)
    if date.future?
      errors.add(:base, 'date should be past or current')
      return false
    end

    path = "historical?#{historical_params(date, source).to_param}"
    self.api_response = exec_api_request(path)&.body

    return quotes if success_api_request?

    errors.add(:base, custom_error_message(api_response_error_code))

    false
  end

  def error_message
    errors.full_messages.uniq.to_sentence
  end

  private

  attr_reader :api_response

  def quotes
    api_response.slice('source', 'quotes').dup.tap do |s|
      s['quotes'].transform_keys! do |key|
        key.last(3)
      end
    end
  end

  def api_response=(response)
    @api_response = ::Oj.load(response) if response.is_a?(String)
  end

  def success_api_request?
    api_response['success'] == true
  end

  def connection
    @connection ||= Excon.new('http://www.apilayer.net/api/',
                              instrumentor: Excon::LoggingInstrumentor)
  end

  def errors
    @errors ||= ActiveModel::Errors.new self
  end

  def historical_params(date, source)
    {
      access_key: API_KEY,
      date: date,
      source: source,
      currencies: Quote::CURRENCIES.join(',')
    }
  end

  def custom_error_message(error_code)
    case error_code
    when 104
      'sorry we have limited resource'
    else
      'Something went wrong'
    end
  end

  def exec_api_request(path)
    connection.get(path: path)
  end

  def api_response_error_code
    api_response['error'] && api_response['error']['code']
  end
end
