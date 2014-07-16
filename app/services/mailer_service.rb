require 'rest-client'

class MailerService
  DEFAULT_FROM = 'support@uber.com'
  DEFAULT_SUBJECT = 'Test email from Uber'
  EMAIL_REGEX = /\A\S+@.+\.\S+\z/

  def initialize(params)
    @params = params
    @from = params[:from] || DEFAULT_FROM
    @name = params[:name]
    @to = params[:to]
    @subject = params[:subject] || DEFAULT_SUBJECT
    @content = params[:content]
    @text = "Hi #{@name},

This is your test content from Uber email service:

#{@content}"
  end

  def validate_params
    raise 'Email is missing' unless @to.present?
    raise 'Content is missing' unless @content.present?
    raise 'Email format is invalid' unless @to =~ EMAIL_REGEX
  end

  def deliver
    begin
      validate_params
    rescue => e
      Rails.logger.error e.message
      return false
    end
    return true if send_via_mailgun || send_via_mandrill
    return false
  end

  def send_via_mailgun
    config = MailgunConfig.config
    begin
      response = RestClient.post config[:url],
        from: @from,
        to: @to,
        subject: @subject,
        text: @text
      return response.code == 200
    rescue => e
      Rails.logger.error "Send via mailgun failed with params: #{@params}, at #{Time.now}"
      return false
    end
  end

  def send_via_mandrill
    config = MandrillConfig.config
    params = {
      key: config[:api_key],
      message: {
        text: @text,
        subject: @subject,
        from_email: @from,
        to: [{ email: @to }]
      }
    }
    begin
      response = RestClient.post config[:url], params.to_json, :content_type => :json
      return response.code == 200
    rescue => e
      Rails.logger.error "Send via mandrill failed with params: #{@params}, at #{Time.now}"
      return false
    end
  end
end
