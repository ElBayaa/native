App.controller 'UsersCtrl', ['$scope', '$http', 'SharedData', ($scope, $http, $sharedData) ->
  # Attributes accessible on the view
  $scope.sharedData = $sharedData

  $scope.setOnlineFriends = (online_friends) ->
    $scope.sharedData.online_friends = online_friends
    $scope.showUsers(online_friends)
    # if online_friends
    # else
    #   $http.get "/api/#{App.version}/users/online_friends"
    #   .success (data)->
    #     $scope.online_friends = data
    #     $scope.showUsers(data)

  $scope.showUsers = (users)->
    $scope.sharedData.displayed_users = users

  $scope.selectChannel = (channel)->
    # check if the channel is already in the active channels list
    existing_channel = $scope.sharedData.active_channels.filter (c)-> c.id == channel.id
    # add the channel if not yet added
    $scope.sharedData.active_channels.push(channel) unless existing_channel.length
    
    # activate channel's tab
    $scope.sharedData.selected_channel = channel
    # get online users who are currently joining the channel
    if channel.users
      $scope.showUsers(channel.users)
    else
      $http.get "/api/#{App.version}/channels/#{channel.id}/online_users"
      .success (data)->
        channel.users = data
        $scope.showUsers(channel.users)
]