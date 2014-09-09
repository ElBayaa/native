App.factory 'Channels', ['$rootScope', '$http', 'Subscription', ($rootScope, $http, $subscription) ->
  
  online_friends_channel = {id: -1, name: 'Online Friends', users: []}
  active_channels = [online_friends_channel]
  selected_channel = online_friends_channel
  
  shared = 
    online_friends_channel: online_friends_channel
    active_channels: active_channels
    selected_channel: selected_channel
]