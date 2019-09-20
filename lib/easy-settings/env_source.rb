require "easy-settings/coercion"

class EasySettings::EnvSource
  attr_reader :prefix, :separator, :converter, :parse_values

  def initialize(prefix, separator: "__", converter: :downcase, parse_values: true)
    @prefix = prefix
    @separator = separator
    @converter = converter
    @parse_values = parse_values
  end

  def load
    {}.tap do |data|
      ENV.each do |variable, value|
        keys = variable.to_s.split(separator)
        next unless keys.shift == prefix

        keys.map!{ |key| key.send(converter) } if converter

        leaf = keys[0...-1].inject(data){ |h, key| h[key] ||= {} }
        leaf[keys.last] = parse_values ? EasySettings::Coercion.new(value).run : value
      end
    end
  rescue NoMethodError => e
    raise "Invalid name converter: #{converter}"
  end
end
