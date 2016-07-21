module Admin::UsersHelper
  def json_config_link user
    bundle_suffix = user.application_info.app_id_suffix
    return '' if bundle_suffix.blank?
    link_to v1_app_configuration_path(bundle_suffix: bundle_suffix) do
      content_tag(:i, '', class: 'panel-title-icon fa fa-download')
    end
  end

  def user_task_completence_check user
    tasks = user.tasks.first(4)
    completed = tasks.take_while do |task|
      task.completed? user
    end.count
    check_or_close tasks.count == completed
  end

  def app_icon_uploaded_check user
    uploaded = user.application_info.app_stores_info.app_icon.exists?
    check_or_close uploaded
  end

  def user_has_used_preview_app_check user
    if user.application_info.json_fetched_by_preview
      content_tag(:i, '', class: 'panel-title-icon fa fa-eye')
    else
      fa_close
    end
  end

  def user_has_live_ios_app_check user
    asi = user.application_info.app_stores_info
    check_or_close asi.itunes_link.present?
  end

  def user_has_live_android_app_check user
    asi = user.application_info.app_stores_info
    check_or_close asi.play_market_link.present?
  end

  def total_installs_count user
    app = user.application_info
    installs = AppInstalls.fetch_installs_from_parse(app, Date.current)
    return 'error' unless installs
    installs.total
  end

  def stop_user_subscription user
    link_to admin_user_subscription_path(user_id: user.id), method: :delete, data: {confirm: "Click OK to cancel user subscription."}, "modal-title" => 'Cancel user subscription?' do
      content_tag(:i, '', class: 'panel-title-icon fa fa-frown-o')
    end
  end

  def ad_frequency_selector user
    current = user.application_info.ad_frequency
    options = options_for_select (0...20).to_a.map { |n| [n, n] }, current
    select_tag :ad_frequency, options, data: {app_id: user.application_info.id}
  end

  def destroy_user user
    link_to admin_users_destroy_user_path(user_id: user.id), method: :delete, data: {confirm: "Click OK to remove user completely."}, "modal-title" => 'Remove user completely?' do
      content_tag(:i, '', class: 'panel-title-icon fa fa-times')
    end
  end
end
