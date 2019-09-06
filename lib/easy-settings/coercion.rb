require "json"

class EasySettings::Coercion
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def run
    case value
    when "false"
      false
    when "true"
      true
    when /^json:/
      JSON.parse(value.gsub(/^json:/, ""))
    when /^\+/ # don't treat +41791234567 as a number
      value
    else
      Integer(value) rescue Float(value) rescue value
    end
  end
end
