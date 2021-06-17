require "easy-settings/coercion"

class EasySettings::CertificateManagerSource < EasySettings::PathSource
  def initialize(base_path, settings_root: ["certificates"], separator: "__", converter: :downcase)
    super(base_path, settings_root: settings_root, separator: separator, converter: converter, parse_values: false)
  end

  def load
    {}.tap do |data|
      Dir["#{base_path}/*"].each do |path|
        next unless File.directory?(path)
        next unless valid_folder?(path)

        variable = path.gsub("#{base_path}/", "")
        keys = settings_root + variable.to_s.split(separator)

        filenames.each do |filename, key|
          value = File.read("#{path}/#{filename}").strip
          assign_value(data, keys + [key], value)
        end
      end
    end
  end

  def valid_folder?(path)
    # ensure the folder contains all the files we expect
    (filenames.keys - Dir["#{path}/*"].map{ |path| File.basename(path) }).none?
  end

  def filenames
    {"ca.crt" => "ca", "tls.crt" => "crt", "tls.key" => "key"}
  end
end
