module I18nFlash
  
  protected

  def t_flash flash_type, t_key, now = false
    message = t(t_key)
    return if message.blank?
    if now
      flash.now[flash_type] = message
    else
      flash[flash_type] = message
    end
  end

  def t_flash_success now = false
    t_flash :success, '.success', now
  end

  def t_flash_error now = true
    t_flash :error, '.failure', now
  end
end