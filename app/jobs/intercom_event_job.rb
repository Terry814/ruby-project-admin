class IntercomEventJob
  include SuckerPunch::Job

  def perform(options)
    Intercom::Event.create(options)
  end
end