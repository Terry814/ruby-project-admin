sqs = AWS::SQS.new(
    access_key_id: ENV['S3_ACCESS_KEY_ID'],
    secret_access_key: ENV['S3_SECRET_ACCESS_KEY']
  )

queue_url = "https://sqs.us-east-1.amazonaws.com/069010411031/instant-build"
$instant_build_queue = sqs.queues[queue_url]