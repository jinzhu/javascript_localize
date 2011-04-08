require 'rubygems'
require 'ya2yaml'
$KCODE='u'

def copy_hash(old,new)
  old.map do |key,value|
    next if new[key] && new[key].class != Hash
    new.update(key => (value.class == Hash) ? (new[key] ? copy_hash(value,new[key]) : value) : value)
  end
  return new
end

namespace :javascript_localize do
  desc 'sync javascript localization files'
  task :sync => :environment do
    result = {}

    I18n.available_locales.map do |x|
      file = File.join(RAILS_ROOT,"config","js_locales","#{x.to_s}.yml")
      result.update({x => file})
      result.update({"#{x.to_s}_content" => 
                    File.exist?(file) ? (YAML.load_file(file) || {}) : {}
      })
    end

    (I18n.available_locales - [I18n.default_locale]).map do |x|
      f = File.new(result[x],'w')
      f << copy_hash(result["#{I18n.default_locale.to_s}_content"],result["#{x.to_s}_content"]).ya2yaml
      f.close
    end
  end

  desc 'build javascript localization files'
  task :build => :environment do
    path = File.join(RAILS_ROOT,'public','javascripts','locales')
    FileUtils.mkdir_p(path) if !File.exist?(path)

    I18n.available_locales.map do |x|
      f = File.new(File.join(path,x.to_s + '.js'),'w')
      f.write '__LocaleString = '
      f.write YAML.load_file(File.join(RAILS_ROOT,'js_locales',"#{x.to_s}.yml")).inspect.gsub(/\"=>\"/,'" : "')
      f.close
    end
  end
end
