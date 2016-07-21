yaml_path = "#{Rails.root}/config/appease_addons.yml"
addons = YAML.load_file(yaml_path)

keys = ['name', 'id', 'description', 'price']
addons.each do |addon|
  keys.each do |key|
    raise "missing key #{key}, please check #{yaml_path}." unless addon.has_key? key
  end
end

ids = addons.map { |addon| addon['id'] }
unless ids.uniq.count == ids.count
  raise "Repeating ids on addons. Please check #{yaml_path} and ensure each id is unique."
end

Rails.configuration.appease_addons = addons.map { |a| OpenStruct.new a }