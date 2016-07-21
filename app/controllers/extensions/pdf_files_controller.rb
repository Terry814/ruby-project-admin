class Extensions::PdfFilesController < Extensions::BaseController
  authorize_resource class: PdfFileItem

  before_action :set_pdf_files
  before_action :set_new_pdf_file, except: :destroy
  before_action :set_pdf_file, only: :destroy

  helper_method :build_new_pdf_file

  def create
    respond_to do |format|
      if @new_pdf_file.update(pdf_file_params)
        t_flash_success
        format.html { redirect_to action: :index }
      else
        t_flash_error
        format.html { render :index }
      end
      format.js
    end
  end

  def destroy
    @pdf_file.destroy!
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

  private

  def set_pdf_files
    @pdf_files = PdfFileItem.of_app current_application
  end

  def set_pdf_file
    @pdf_file = @pdf_files.find(params[:id])
  end

  def set_new_pdf_file
    @new_pdf_file = build_new_pdf_file
  end

  def build_new_pdf_file
    PdfFileItem.build_with_application_info current_application
  end

  def pdf_file_params
    params.require(:pdf_file_item).permit(:pdf_file, menu_item_attributes: [:display_name])
  end
end