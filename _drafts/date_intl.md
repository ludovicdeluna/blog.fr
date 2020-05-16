---
---

~~~ruby
require 'i18n'
require 'date'

I18n.config.available_locales = :en, :"fr-FR"
I18n.default_locale = :"fr-FR"
I18n.l(Date.today, format: :human)


I18n.load_path << Dir[File.expand_path("data/locales") + "/*.yml"]
I18n.default_locale = :"fr-FR"
I18n.l(Date.today, format: short)
I18n.l(Date.today, format: :long)
~~~
