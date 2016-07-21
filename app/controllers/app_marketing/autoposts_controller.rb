class AppMarketing::AutopostsController < AppMarketing::BaseController
  before_action :set_autopost
  check_authorization

  def show 
    authorize! :show, :autoposts
  end

  def update
    authorize! :use, :autoposts

    source_accounts_ids = params.require(:autopost)
      .delete(:social_source_account_ids)
      .select(&:present?).map(&:to_i)
    output_connections_ids = params.require(:autopost)
      .delete(:identity_ids).select(&:present?).map(&:to_i)

    respond_to do |format|
      if @autopost.update(autopost_params)
        update_sources(@autopost, source_accounts_ids)
        update_connections(@autopost, output_connections_ids)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  private

  def set_autopost
    @autopost = Autopost.find_or_initialize_by(application_info: current_application)
  end

  def autopost_params
    params.require(:autopost).permit(:enabled, :interval, :randomized, :hashtag, :url)
  end

  def update_sources autopost, source_ids
    # remove already added from source ids, to leave new to add sources
    autopost.social_source_accounts.each do |acc|
      if !source_ids.delete(acc.id)
        autopost.social_source_accounts.destroy(acc)
      end
    end
    if source_ids.any?
      autopost.social_source_accounts << SocialSourceAccount.find(source_ids)
    end
  end

  def update_connections autopost, connection_ids
    # remove already added from connections ids, to leave new to add ones
    autopost.identities.each do |i|
      if !connection_ids.delete(i.id)
        autopost.identities.destroy(i)
      end
    end
    if connection_ids.any?
      autopost.identities << Identity.find(connection_ids)
    end
  end
end
