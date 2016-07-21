class GenerateCoverJob
  include SuckerPunch::Job
  
  def perform(app)
    ActiveRecord::Base.connection_pool.with_connection do
      @app_name = app.app_stores_info.ios_app_name || app.user.company_name
    end
    @app_name.upcase!

    image_file = generate_image
    return unless image_file

    ActiveRecord::Base.connection_pool.with_connection do
      app.reload
      app.cover_image = image_file
      app.save
    end
    image_file.unlink
  end

  def generate_image
    file = Tempfile.new([@app_name.parameterize,'.png'])
    file.binmode

    background_path = Rails.root.join('app/assets/images/default_cover.png').to_s

    parameters = [
      ':source',
      '-gravity center',
      '-fill white',
      '-pointsize 28',
      '-annotate 0 :text', 
      ':dst'
    ].join(' ')

    success = Paperclip.run("convert", parameters, source: background_path, text: @app_name, dst: File.expand_path(file.path))
    
    success ? file : false
  end
end