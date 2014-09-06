App.controller 'ChannelsCtrl', ['$scope', '$http', 'Channels', ($scope, $http, $channels) ->

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

  $scope.selectChannel = (channel)->
    # check if the channel is already in the active channels list
    existing_channel = $channels.active_channels.filter (c)-> c.id == channel.id
    # add the channel if not yet added
    $channels.active_channels.push(channel) unless existing_channel.length

    $channels.selected_channel = channel
]