class Users::SessionsController < Devise::SessionsController
  def destroy
    su_provider = SwitchUser::Provider.init(self)
    original_user = su_provider.original_user
    super
    if original_user
      su_provider.remember_current_user false
      sign_in original_user
    end
  end
end