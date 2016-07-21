# used by intercom module AjaxFlash
module RealUserHelper
  def original_user
    provider = SwitchUser::Provider.init(self)
    provider.original_user || current_user
  end
end