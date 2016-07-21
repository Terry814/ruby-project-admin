class AppSettings::ConnectionsController < AppSettings::BaseController
  authorize_resource class: SocialStream
  before_action :set_identity, only: [
                                      :connection_show,
                                      :fb_callback,
                                      :tw_callback,
                                      :ig_callback,
                                      :disconnect_facebook,
                                      :disconnect_twitter,
                                      :disconnect_instagram,
                                     ]

  def set_identity
    @kind
    if params[:kind].present?
      @kind = params[:kind]
    elsif params[:action] =~ /_callback$/
      @kind = {
        :tw => :twitter, 
        :ig => :instagram, 
        :fb => :facebook
      }[params[:action].gsub(/_callback$/, '').to_sym]
    elsif params[:action] =~ /^disconnect_/
      @kind = params[:action].gsub(/^disconnect_/, '').to_sym
    end

    unless @kind.nil?
      @identity = current_user.identities.find_or_initialize_by(provider: Identity.providers[@kind])
    end
  end

  def connection_show
  end

  def connect_facebook
    redirect_to facebook_oauth_dialog_url
  end

  def disconnect_facebook
    @identity.destroy!
    respond_to do |format|
      format.html { redirect_to action: :connection_show, kind: :facebook }
      format.js
    end
  end

  def fb_callback
    error_message = params['error_message']

    if params['code'].present?
      token_res = HTTParty.get(facebook_code_exchange_url(params['code']))
      access_token = token_res['access_token']

      if access_token.present?
        graph = Koala::Facebook::API.new(access_token)
        user_id = graph.get_object("me")['id']

        @identity.update(
                         uid: user_id,
                         access_token: access_token,
                         expires_at: token_res['expires_in'].seconds.from_now
                         )
        redirect_to action: :connection_show, kind: :facebook
        return
      end
      error_message = token_res['error']['message']
    end

    unless params['error_reason'] == 'user_denied'
      flash.now[:error] = error_message || t('.failure')
      flash.keep
    end
    redirect_to action: :connection_show, kind: :facebook
  end

  def connect_instagram
    redirect_to instagram_oauth_dialog_url
  end

  def disconnect_instagram
    @identity.destroy!
    respond_to do |format|
      format.html { redirect_to action: :connection_show, kind: :instagram }
      format.js
    end
  end

  def ig_callback
    error_message = params['error_message']

    if params['code'].present?
      token_res = HTTParty.post("https://api.instagram.com/oauth/access_token",
        body: instagram_code_exchange_params(params['code']))
      if token_res['user'].present?
        @identity.update(
                         uid: token_res['user']['id'],
                         access_token: token_res['access_token']
                         )
        redirect_to action: :connection_show, kind: :instagram
        return
      end
      
      error_message = token_res['error_message']
    end
    
    unless params['error_reason'] == 'user_denied'
      flash.now[:error] = error_message || t('.failure')
      flash.keep
    end
    redirect_to action: :connection_show, kind: :instagram
  end

  def connect_twitter
    res = TwitterOauth::Client.request_token oauth_twitter_url
    if res[:oauth_callback_confirmed]
      redirect_to twitter_oauth_dialog_url(res[:oauth_token]) and return
    end

    flash.now[:error] = res[:error] || t('.failure')
    render 'show'
  end

  def disconnect_twitter
    @identity.destroy!
    respond_to do |format|
      format.html { redirect_to action: :connection_show, kind: :twitter }
      format.js
    end
  end

  def tw_callback
    if params['oauth_token'].present?
      res = TwitterOauth::Client.exchange_access_token(params['oauth_token'], params['oauth_verifier'])
      @identity.update(
                       uid: res[:user_id],
                       access_token: res[:oauth_token],
                       access_token_secret: res[:oauth_token_secret]
                       )
      redirect_to action: :connection_show, kind: :twitter
      return
    end

    unless params[:denied].present?
      flash.now[:error] = t('.failure');
      flash.keep
    end
    redirect_to action: :connection_show, kind: :twitter
  end

  private

  def facebook_oauth_dialog_url
    params = { client_id: ENV['FB_APP_ID'], redirect_uri: oauth_facebook_url }
    "https://www.facebook.com/dialog/oauth?#{params.to_query}"
  end

  def facebook_code_exchange_url code
    params = { client_id: ENV['FB_APP_ID'], client_secret: ENV['FB_SECRET_KEY'],
      code: code, redirect_uri: oauth_facebook_url }
    "https://graph.facebook.com/v2.3/oauth/access_token?#{params.to_query}"
  end

  def instagram_oauth_dialog_url
    params = { client_id: ENV['INSTAGRAM_CLIENT_ID'],
      redirect_uri: oauth_instagram_url, response_type: :code }
    "https://api.instagram.com/oauth/authorize/?#{params.to_query}"
  end

  def instagram_code_exchange_params code
    { client_id: ENV['INSTAGRAM_CLIENT_ID'], client_secret: ENV['INSTAGRAM_CLIENT_SECRET'],
      code: code, redirect_uri: oauth_instagram_url, grant_type: :authorization_code }
  end

  def twitter_oauth_dialog_url token
    "https://api.twitter.com/oauth/authorize?oauth_token=#{token}"
  end
end
