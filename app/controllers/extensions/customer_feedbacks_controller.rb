class Extensions::CustomerFeedbacksController < Extensions::BaseController
  authorize_resource class: CustomerFeedback

  before_action :set_customer_feedback
  before_action :ensure_customer_feedback, only: :update_info

  def update
    respond_to do |format|
      if @feedback.update(feedback_menu_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  def update_info
    @feedback.updating_info = true
    respond_to do |format|
      if @feedback.update(feedback_info_params)
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

  def set_customer_feedback
    @feedback = CustomerFeedback.first_of_app_or_initialize current_application
  end

  def ensure_customer_feedback
    if @feedback.new_record?
      @feedback.menu_item.enabled = true
      @feedback.menu_item.display_name = "Customer Feedback"
      @feedback.save
    end

  end

  def feedback_menu_params
    params.require(:customer_feedback).permit(menu_item_attributes: [:display_name, :enabled, :id])
  end

  def feedback_info_params
    params.require(:customer_feedback).permit(:email, :trip_advisor_url, :yelp_url, :message_threshold, :message)
  end
end