require 'mailgun_config'

MailgunConfig.config = YAML.load_file("config/mailgun.yml")[Rails.env].symbolize_keys
