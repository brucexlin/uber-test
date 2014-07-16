require 'mandrill_config'

MandrillConfig.config = YAML.load_file("config/mandrill.yml")[Rails.env].symbolize_keys
