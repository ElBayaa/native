App.factory 'SharedData', ['$http', ($http) ->
  
  online_friends_channel = {id: -1, name: 'Online Friends'}
  online_friends = []
  displayed_users = []
  active_channels = [online_friends_channel]
  selected_channel = online_friends_channel

  shared = 
    online_friends: online_friends
    displayed_users: displayed_users
    active_channels: active_channels
    selected_channel: selected_channel

  shared
]