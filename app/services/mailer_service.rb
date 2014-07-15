require 'rest-client'

class MailerService
  DEFAULT_FROM = 'support@uber.com'
  DEFAULT_SUBJECT = 'Test email from Uber'

  def initialize(params)
    @params = params
    @from = params[:from] || DEFAULT_FROM
    @name = params[:name]
    @to = params[:to]
    @subject = params[:subject] || DEFAULT_SUBJECT
    @text = "Hi #{params[:name]},

This is your test content from Uber email service:

#{params[:content]}"
  end

  def deliver
    return 200 if send_via_mailgun || send_via_mandrill
    return 500
  end

  def send_via_mailgun
    url = YAML::load(File.open("#{Rails.root}/config/mailgun.yml"))[Rails.env]['url']
    begin
      response = RestClient.post url,
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
    config = YAML::load(File.open("#{Rails.root}/config/mandrill.yml"))[Rails.env]
    params = {
      key: config['api_key'],
      message: {
        text: @text,
        subject: @subject,
        from_email: @from,
        to: [{ email: @to }]
      }
    }
    begin
      response = RestClient.post config['url'], params.to_json, :content_type => :json
      return response.code == 200
    rescue => e
      Rails.logger.error "Send via mandrill failed with params: #{@params}, at #{Time.now}"
      return false
    end
  end
end
