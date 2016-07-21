class IntercomUserCreateJob
  include SuckerPunch::Job

  def perform(options)
    Intercom::User.create(options)
  end
end