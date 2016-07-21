class AssociatedBubblingValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.nil?
      (value.is_a?(Array) ? value : [value]).each do |v|
        unless v.valid?
          v.errors.full_messages.each do |msg|
            record.errors.add(attribute, msg, options.merge(:value => value))
          end
        end
      end
    end
  end
end