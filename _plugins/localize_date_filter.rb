# The intl lib is integrated by Jekyll
# https://github.com/ruby-i18n/i18n
# Integration with Ruby on Rails - for examples
# https://guides.rubyonrails.org/i18n.html#adding-date-time-formats
# All Localisation files from Ruby on Rails. Extract only date information
# https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale
#
# All files required for en / fr are in data/locales/*.yml
require 'date'
require 'i18n'

module Jekyll
  module LocalizeDateFilter
    def localize_date(time, format = "default")
      set_locale

      date_format = case format
      when "long" then :long
      when "short" then :short
      when "default" then :default
      else raise "Format #{format} unknown"
      end

      I18n.l(time.to_date, format: date_format)
    end

    private

    def set_locale
      self.default_locale = config["locale"] || "en" unless @default_locale
    end

    def default_locale=(locale)
      @default_locale = locale.to_sym
      I18n.default_locale = @default_locale
    end

    def config
      @context.registers[:site].config
    end
  end
end

I18n.load_path << Dir[File.expand_path("_data/locales") + "/*.yml"]
Liquid::Template.register_filter(Jekyll::LocalizeDateFilter)
