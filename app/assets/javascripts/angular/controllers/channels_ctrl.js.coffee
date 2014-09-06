App.controller 'ChannelsCtrl', ['$scope', '$http', '$cookieStore', 'Channels', ($scope, $http, $cookieStore, $channels) ->

  $scope.active_channels = $channels.active_channels
  $scope.selected_channel = $channels.selected_channel
  
  # watch changes of active channels and update $scope data in response
  $scope.$watch (()-> $channels.active_channels), (new_channels, old_channels)->
    $scope.active_channels = new_channels

  # if the user clicked on a channel, we need to activate its tab
  $scope.$watch (()-> $channels.selected_channel), (new_channel, old_channel)->
    $scope.selected_channel = new_channel
    unless new_channel.users
      $http.get "/api/#{App.version}/channels/#{new_channel.id}/online_users"
      .success (data)->
        new_channel.users = data
  
  $scope.setOnlineFriends = (online_friends) ->
    $channels.setOnlineFriends(online_friends)
  
  $scope.fetchLastActiveChannels = () ->
    http_cong =
      method: 'GET'
      url: "/api/#{App.version}/channels/"
      params:
        'ids[]': $cookieStore.get('active_channels')
    $http(http_cong).success (channels)->
      $channels.resetActiveChannels()
      for channel in channels
        $channels.active_channels.push(channel)

  $scope.selectChannel = (channel)->
    # check if the channel is already in the active channels list
    existing_channel = $channels.active_channels.filter (c)-> c.id == channel.id
    # add the channel if not yet added
    unless existing_channel.length
      $channels.active_channels.push(channel)
      last_channels = $cookieStore.get('active_channels') || []
      last_channels.push(channel.id) 
      $cookieStore.put('active_channels', last_channels)

    $channels.selected_channel = channel

  $scope.removeChannel = (index)->
    channel = $channels.active_channels[index]
    
    return if channel.id == -1 # can't remove Online Users Channel
    
    $channels.active_channels.splice index, 1
    
    # remove the channel from last channels cookie
    # the index in the cookie will be (index - 1) as we add and remove from active_channels and active_channels cookie at the same time
    # but active_channels cookie don't contain the first channel (online friends) and that is why we subtracted that one
    last_channels = $cookieStore.get('active_channels')
    last_channels.splice(index-1, 1) 
    $cookieStore.put('active_channels', last_channels)

    # if the removed channel is the currently selected one then select the previous channel 
    if channel.id == $channels.selected_channel.id
      $scope.selectChannel($channels.active_channels[index - 1])

]