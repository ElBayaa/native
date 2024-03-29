App.controller 'ChannelsCtrl', ['$scope', '$http', 'Channels', 'User', 'Subscription', ($scope, $http, $channels, $user, $subscription) ->

  $scope.active_channels = $channels.active_channels
  $scope.selected_channel = $channels.selected_channel
  
  # watch changes of active channels and update $scope data in response
  $scope.$watch (()-> $channels.active_channels), (new_channels, old_channels)->
    $scope.active_channels = new_channels
  , true
  # if the user clicked on a channel, we need to activate its tab
  $scope.$watch (()-> $channels.selected_channel), (new_channel, old_channel)->
    $scope.selected_channel = new_channel
  , true

  $scope.selectChannel = (channel)->
    # add the channel if not yet added
    unless _.find($channels.active_channels, (c) -> c.id.toString() == channel.id.toString())
      $channels.active_channels.push(channel)

    $channels.selected_channel = channel

  $scope.removeChannel = (index)->
    channel = $channels.active_channels[index]
    
    return if channel.id == -1 # can't remove Online Users Channel
    
    $channels.active_channels.splice index, 1
    
    # if the removed channel is the currently selected one then select the previous channel 
    if channel.id == $channels.selected_channel.id
      $scope.selectChannel($channels.active_channels[index - 1])

]