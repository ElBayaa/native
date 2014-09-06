App.factory 'Channels', ['$http', ($http) ->
  
  online_friends_channel = {id: -1, name: 'Online Friends', users: []}
  active_channels = [online_friends_channel]
  selected_channel = online_friends_channel
  
  setOnlineFriends = (friends)->
    online_friends_channel.users = friends
  
  resetActiveChannels = (channels)->
    active_channels = [online_friends_channel]

  shared = 
    active_channels: active_channels
    selected_channel: selected_channel
    setOnlineFriends: setOnlineFriends
    resetActiveChannels: resetActiveChannels
]