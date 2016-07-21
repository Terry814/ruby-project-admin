class V1::AppConfigurationController < ApplicationController
  layout 'devise', only: :download_page
  before_action :find_app_by_suffix, only: [:download_page, :config_json]

  def download_page
    files = bucket.objects.with_prefix("instant/#{@app_info.app_id_suffix}/").map(&:key)
    base_url = 'https://appease.s3.amazonaws.com/'

    # check if has manifest
    ios_manifest = files.find { |f| File.basename(f) == 'manifest.plist' }
    @ios_url = "itms-services://?action=download-manifest&amp;url=#{URI.join(base_url, URI.encode(ios_manifest))}" if ios_manifest

    # check if there is apk file
    apk = files.find { |f| File.basename(f) == 'Appease Instant.apk' }
    @android_url = URI.join(base_url, URI.encode(apk)).to_s if apk

    @app_name = @app_info.app_stores_info.ios_app_name || @app_owner.company_name
    report_event 'visited-download-instant-app-page', @app_owner.id
  end

  def config_json
    if params[:from_instant] && !@app_info.json_fetched_by_instant
      @app_info.update(json_fetched_by_instant: true)
      report_event 'launched-instant-app', @app_owner.id
      update_intercom_user @app_owner.id, used_instant_app: true
    end
    render 'config'
  end

  def info
    @app_info = if params[:email].present?
      User.find_by!(email: params[:email].downcase).application_info
    else
      ApplicationInfo.find_by!(app_id_suffix: params[:app_id])
    end
    @app_owner = @app_info.user

    if params[:from_preview] && !@app_info.json_fetched_by_preview
      @app_info.update(json_fetched_by_preview: true)
      report_event 'used-preview-app', @app_owner.id
      update_intercom_user @app_owner.id, user_preview_app: true
    end

    ability = Ability.new(@app_owner)
    @push_enabled = ability.can? :manage, :push_notifications
    @app_stores_info = @app_info.app_stores_info
  end

  def location_messages
    scope = if ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(params[:exit])
      GeoMessage.current.exit
    else
      GeoMessage.current.entry
    end
    locations = scope.where(contact_location_id: params[:id])
                     .map { |loc| loc.attributes.symbolize_keys.slice(:id, :message, :one_time_notification) }
    render json: { messages: locations }
  end

  def ios_ads
    render json: { ids: AdPlacementId.ios_ads.map(&:placement_id) }
  end

  def android_ads
    render json: { ids: AdPlacementId.android_ads.map(&:placement_id) }
  end

  private

  def find_app_by_suffix
    bundle_suffix = params[:bundle_suffix]
    @app_info = ApplicationInfo.find_by!(app_id_suffix: bundle_suffix)
    @app_owner = @app_info.user
  end

  def report_event name, user_id, metadata = {}
    create_intercom_event(
      event_name: name,
      created_at: Time.now.to_i,
      user_id: user_id,
      metadata: metadata
    )
  end

  def update_intercom_user user_id, attributes
    create_intercom_user(
      user_id: user_id,
      custom_attributes: attributes
    )
  end

  def bucket
    s3 = AWS::S3.new(
      access_key_id: ENV['S3_ACCESS_KEY_ID'],
      secret_access_key: ENV['S3_SECRET_ACCESS_KEY']
    )
    s3.buckets[ENV['S3_BUCKET_NAME']]
  end
end