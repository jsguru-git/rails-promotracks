module PromoRails
  class Settings < Settingslogic
    #source "#{Rails.root}/config/application.yml"
    namespace Rails.env

    class AssetStore < Settingslogic
      source File.join(File.dirname(__FILE__), '../..', 'config', 'settings', 'asset_store.yml')
      namespace Rails.env
    end

    class SES < Settingslogic
      source File.join(File.dirname(__FILE__), "../..", "config", "settings", "ses.yml")
      namespace Rails.env
    end
  end
end