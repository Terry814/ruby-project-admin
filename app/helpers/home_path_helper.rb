module HomePathHelper
  def home_path_with_company_name
    home_path(company_name: current_user.company_name.parameterize)
  end

  extend ActiveSupport::Concern
  included do
    def redirect_to_home
      redirect_to_page home_path_with_company_name
    end
  end
end