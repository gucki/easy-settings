class EasySettings::Struct
  include Enumerable

  UnknownPropertyError = Class.new(StandardError)

  delegate :each, to: :@properties

  def self.import(hash)
    new.tap do |struct|
      hash.each do |k, v|
        case v
        when Hash
          v = import(v)
        when Array
          v = v.collect{ |i| i.is_a?(Hash) ? import(i) : i }
        end
        struct[k] = v
      end
    end
  end

  def initialize(properties = {})
    @properties = properties
  end

  def [](property)
    @properties.fetch(property.to_s){ raise_unknown_property(property) }
  end

  def []=(property, value)
    @properties[property.to_s] = value
  end

  def try(property)
    @properties[property.to_s]
  end

  def to_h
    @properties.transform_values{ |v| v.is_a?(EasySettings::Struct) ? v.to_h : v }
  end

  def respond_to?(property, include_private = false)
    @properties.has_key?(property.to_s)
  end

  def method_missing(method, *args)
    method = method.to_s
    return @properties.fetch(method) unless method.end_with?("=")
    property = method[0..-2]
    @properties[property] = args[0]
  rescue KeyError => e
    raise_unknown_property(method)
  end

  def raise_unknown_property(property)
    raise UnknownPropertyError, "unknown property #{property.inspect} (#{@properties.keys.map(&:inspect).join(", ")})"
  end
end
