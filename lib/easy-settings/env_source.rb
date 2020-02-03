require "easy-settings/path_source"

class EasySettings::EnvSource < EasySettings::PathSource
  attr_reader :prefix

  def initialize(prefix, separator: "__", converter: :downcase, parse_values: true)
    @prefix = prefix
    super(nil, separator: separator, converter: converter, parse_values: parse_values)
  end

  def load
    {}.tap do |data|
      ENV.each do |variable, value|
        keys = variable.to_s.split(separator)
        next if prefix.present? && keys.shift != prefix

        assign_value(data, keys, value)
      end
    end
  end
end
