# frozen_string_literal: true

require 'i18n'

I18n.load_path = Dir['config/locales/en.yml']

def t(key, options = {})
  I18n.t(key, options)
end
