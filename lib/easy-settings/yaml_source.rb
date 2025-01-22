require "yaml"
require "erb"

class EasySettings::YamlSource
  attr_reader :path

  def initialize(path)
    @path = path.to_s
  end

  def load
    File.exist?(path) ? (YAML.load(ERB.new(IO.read(path)).result) || {}) : {}
  rescue StandardError => e
    raise "Error occurred while parsing #{path}: #{e.message}"
  end
end
