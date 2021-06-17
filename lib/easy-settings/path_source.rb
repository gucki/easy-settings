require "easy-settings/coercion"

class EasySettings::PathSource
  attr_reader :base_path, :settings_root, :separator, :converter, :parse_values

  def initialize(base_path, settings_root: [], separator: "__", converter: :downcase, parse_values: true)
    @base_path = base_path.to_s
    @settings_root = settings_root
    @separator = separator
    @converter = converter
    @parse_values = parse_values
  end

  def load
    {}.tap do |data|
      Dir["#{base_path}/*"].each do |path|
        next unless File.file?(path)

        variable = path.gsub("#{base_path}/", "")
        keys = settings_root + variable.to_s.split(separator)
        value = File.read(path).strip
        assign_value(data, keys, value)
      end
    end
  end

  def assign_value(data, keys, value)
    keys.map! do |key|
      next key.to_i if key =~ /^\d+/
      next key.send(converter) if converter
      key
    rescue NoMethodError => e
      raise "Invalid name converter: #{converter}"
    end

    leaf = keys[0...-1].each_with_index.inject(data){ |h, (key, i)| h[key] ||= keys[i + 1].is_a?(Integer) ? [] : {} }
    leaf[keys.last] = parse_values ? EasySettings::Coercion.new(value).run : value
  end
end
