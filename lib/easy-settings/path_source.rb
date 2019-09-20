require "easy-settings/coercion"

class EasySettings::PathSource
  attr_reader :base_path, :separator, :converter, :parse_values

  def initialize(base_path, separator: "__", converter: :downcase, parse_values: true)
    @base_path = base_path.to_s
    @separator = separator
    @converter = converter
    @parse_values = parse_values
  end

  def load
    {}.tap do |data|
      Dir["#{base_path}/*"].each do |path|
        next unless File.file?(path)

        variable = path.gsub("#{base_path}/", "")
        value = File.read(path).strip

        keys = variable.to_s.split(separator)
        keys.map!{ |key| key.send(converter) } if converter

        leaf = keys[0...-1].inject(data){ |h, key| h[key] ||= {} }
        leaf[keys.last] = parse_values ? EasySettings::Coercion.new(value).run : value
      end
    end
  rescue NoMethodError => e
    raise "Invalid name converter: #{converter}"
  end
end
