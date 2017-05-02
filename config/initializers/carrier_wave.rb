# put this in config/initializers/carrierwave.rb
require 'carrierwave/storage/fog'
require 'platform/settings'

CarrierWave.configure do |config|

  case PromoRails::Settings::AssetStore.store

    when 'AWS'
      config.storage = :fog
      config.permissions = 0600
      config.fog_credentials = {
          :provider => PromoRails::Settings::AssetStore.store,
          :aws_access_key_id => PromoRails::Settings::AssetStore.s3_access_key_id,
          :aws_secret_access_key => PromoRails::Settings::AssetStore.s3_secret_access_key,
          :region => PromoRails::Settings::AssetStore.s3_media_region,
          :path_style => true
      }
      config.fog_directory = PromoRails::Settings::AssetStore.s3_media_bucket
      config.asset_host = PromoRails::Settings::AssetStore.s3_media_root

    when 'local'
      config.storage = :file
      config.fog_credentials = {
          :provider => 'Local',
          :local_root => "#{Rails.root}/public",
      }
    # config.fog_directory = BlockIt::Settings::AssetStore.store.s3_media_root
    # config.storage = :file
  end

  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'} # optional, defaults to {}
  config.fog_public = true


end