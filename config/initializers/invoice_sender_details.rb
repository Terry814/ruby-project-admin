details = YAML.load_file("#{Rails.root}/config/invoice_sender_details.yml")
Rails.configuration.invoice_sender_details = OpenStruct.new details