require "active_support"
require "active_support/core_ext/module/delegation"

require "easy-settings/version"
require "easy-settings/struct"
require "easy-settings/env_source"
require "easy-settings/path_source"
require "easy-settings/certificate_manager_source"
require "easy-settings/yaml_source"

class EasySettings
  delegate :respond_to?, to: :@data

  def initialize(sources: [], fail_on_missing: true)
    @sources = sources
    @fail_on_missing = fail_on_missing
    reload!
  end

  def reload!
    config = {}
    @sources.each do |source|
      data = source.load
      config.deep_merge!(data)
    end
    @data = EasySettings::Struct.import(config)
  end

  def method_missing(method_name, *args)
    @data.send(method_name, *args)
  rescue EasySettings::Struct::UnknownPropertyError => e
    return unless @fail_on_missing
    raise e
  end
end
