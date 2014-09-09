App.factory 'Subscription', [ '$http', ($http) ->
  
  server_url = "http://localhost:9292/faye"
  secret_token = "secret"

  initialize = (options)->
    server_url = options.server_url || "http://localhost:9292/faye"
    secret_token = options.secret_token || "secret"

  subscribeTo = (channel, onMsgCallback)->  
    timestamp = Date.now()
    
    PrivatePub.sign
      channel: channel
      timestamp: timestamp
      server: server_url
      signature: SHA1(secret_token + channel + timestamp)

    PrivatePub.subscribe channel, onMsgCallback

  unsubscribeFrom = (channel)->
    PrivatePub.unsubscribe(channel)

  publishTo = (channel, info)->
    $http.post server_url, formMessage(channel, JSON.stringify(info))
   
  formMessage = (channel, info)->
    message = 
      channel: channel
      data:
        channel: channel
      ext:
        private_pub_token: secret_token

    if typeof(info) == 'String'
      message['data']['eval'] = info
    else
      message['data']['data'] = info
    
    message
  
  output = 
    initialize: initialize
    subscribeTo: subscribeTo
    unsubscribeFrom: unsubscribeFrom
    publishTo: publishTo
]