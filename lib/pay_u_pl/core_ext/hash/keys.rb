# frozen_string_literal: true

class Hash
  def camelize_keys(uppercase_first_letter: false)
    deep_transform_keys do |key|
      capitalized = key.to_s.split("_").collect(&:capitalize).join
      capitalized[0] = capitalized[0].downcase unless uppercase_first_letter
      capitalized
    end
  end

  def underscore_keys
    deep_transform_keys do |key|
      underscore = key.to_s.gsub(/([A-Z])([A-Z])/, '\1_\2')
      underscore.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      underscore.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      underscore.tr!("-", "_")
      underscore.downcase!
      underscore
    end
  end
end
