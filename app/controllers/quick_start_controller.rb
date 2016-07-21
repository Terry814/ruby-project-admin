class QuickStartController < ApplicationController
  layout 'clean'

  include SocialLinkHelper

  def show
    if signed_in? && current_user.admin?
      created_user = cookies.delete(:created_user)
      if created_user.present?
        become_link = view_context.link_to "here", admin_become_path(user_id: created_user)
        flash.now[:success] = "User successfully created. Press #{become_link} to sign in as user.".html_safe
      end
      flash.now[:notice] = "You are creating user in admin mode. Claim account email will be sent to user when build is ready."
    end
    cookies[:app_name] = params[:app_name] if params[:app_name].present?
  end

  def links
    redirect_to action: :show unless request.format.js?
    scarper = WebsiteScarper::Scarper.new(params[:url])
    scarper.scarpe(15, 1)
    @web_links = scarper.links(10, 0)
    @social_links = scarper.social_links.select { |l| social_account?(l.link) }
  end

  def create_user
    is_admin = signed_in? && current_user.admin?
    # create user
    user_attrs = user_params.to_h

    if is_admin
      if user_attrs['password_confirmation'].blank? || user_attrs['password'].blank?
        password = Devise.friendly_token.first(10)
        user_attrs['password'] = user_attrs['password_confirmation'] = password
      end
    end

    user_attrs.merge!(
      terms: '1',
      sign_up_method: is_admin ? 'admin' : 'wizard'
    )

    user = User.new(user_attrs)
    if !user.save
      reason = user.errors.full_messages.join(', ')
      respond_to do |format|
        flash.now[:error] = "Couldn't create user: #{reason}"
        format.html { render :show }
        format.js { render js: '' }
      end and return
    end

    skip_intercom = wizard_params[:user][:skip_intercom] == '1'
    create_intercom_user_from_user user unless skip_intercom

    app_name = wizard_params[:app_name] || cookies.delete(:app_name)
    user.application_info.app_stores_info.update_columns(
      ios_app_name: app_name, android_app_name: app_name
    ) if app_name.present?

    populate_links user.application_info

    # generate social accounts
    SocialLinksImportJob.new.perform(user.application_info, enabled_social_links)

    # generate cover image
    GenerateCoverJob.new.async.perform(user.application_info)

    # send previews link sms
    if user_attrs['phone_number'].present?
      SmsPreviewsLinkJob.new.async.perform(user_attrs['phone_number'])
    end

    path = if is_admin
      cookies[:created_user] = { value: user.id, expires: 1.minute.from_now }
      quick_start_path
    else
      sign_in user
      home_path(company_name: user.company_name.parameterize)
    end

    respond_to do |format|
      format.html { redirect_to path }
      format.js { render js: "window.location = '#{path}'" }
    end
  end

  private

  def user_params
    wizard_params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :phone_number, :company_name)
  end

  def wizard_params
    params.fetch(:new_user)
  end

  def populate_links app
    enabled_web_links.each do |link|
      web_link = WebLink.build_with_application_info app
      web_link.update(url: link[:url], menu_item_attributes: {display_name: link[:title]})
    end
  end

  def enabled_web_links
    links = wizard_params[:web_links] || {}
    links.values.select { |h| h[:show] == '1' }
  end

  def enabled_social_links
    links = wizard_params[:social_links] || {}
    links.values
      .select { |h| h[:show] == '1' }
      .map { |h| h[:url] }
  end
end
