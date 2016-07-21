module ExceptionResponders
  extend ActiveSupport::Concern
  included do
    rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.html { render file: File.join(Rails.root, 'public', '403'), status: 403, layout: false }
        format.js { head :forbidden }
        format.json { render json: {error: 'forbidden', status: 403}, status: 403 }
      end
    end

    unless Rails.env.development?
      rescue_from Exception do |exception|
        puts exception.message
        respond_to do |format|
          format.html { render file: File.join(Rails.root, 'public', '500'), status: 500, layout: false }
          format.js { head :internal_server_error }
          format.json { render json: {error: 'server_error', status: 500}, status: 500 }
        end
      end
      
      rescue_from ActiveRecord::RecordNotFound, AbstractController::ActionNotFound, ActionController::RoutingError do |exception|
        respond_to do |format|
          format.html { render file: File.join(Rails.root, 'public', '404'), status: 404, layout: false }
          format.js { head :not_found }
          format.json { render json: {error: 'not_found', status: 404}, status: 404 }
        end
      end
    end
  end
end