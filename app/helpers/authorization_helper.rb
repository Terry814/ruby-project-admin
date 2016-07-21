module AuthorizationHelper
  def upgrade_message_for! feature
    return "" if can? :manage, feature
    html = <<-HTML
    <div class="alert alert-info alert-dark">
      <button type="button" class="close" data-dismiss="alert">&times;</button>
      You must #{link_to('upgrade', accounts_appease_packages_path)} to <strong>Marketer</strong> or <strong>Enterprise</strong> to access these features.
    </div>
    HTML

    html.html_safe
  end
end
