ENV['PAGER'] = 'more'

Pry.config.color = true

Pry.config.prompt = proc do |obj, nest_level, _pry_|
  version = []
  version << "Rails#{Rails.version}" if defined? Rails
  version << "\001\e[0;31m\002"
  version << "(#{RUBY_VERSION})"
  version << "\001\e[0m\002"

  "#{version.join} #{Pry.config.prompt_name} (#{Pry.view_clip(obj)})> "
end