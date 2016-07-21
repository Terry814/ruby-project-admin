class SmsPreviewsLinkJob
  include SuckerPunch::Job

  def perform(phone_number)
    client = Twilio::REST::Client.new
    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'] || '+16506514930',
      to: phone_number,
      body: 'Download the Previews app to see the AppEase you just created. iOS: http://bit.ly/appease-ios Android: http://bit.ly/appease-android'
    )
  end
end
