App.controller 'VistorsWatcher', ['$scope', 'Channels', 'Subscription', ($scope, $channels, $subscription)->
  
  $scope.current_user
  $scope.friends_last_seen_at = {}
    
  $scope.setCurrentUser = (u)->
    $scope.current_user = u

    # subscribe to friends' channels so that I can receive there pulses
    for id in $scope.current_user.friends_ids
      $subscription.subscribeTo "/users/#{id}", (data, subscribed_channel)->
        $scope.receiveFriendPulse(JSON.parse(data))

    # send a pulse that I am joined
    setTimeout ()->
      $subscription.publishTo "/users/#{$scope.current_user.id}", {action: 'user_joined', user: $scope.current_user}
    , 2000

    # send a pulse that I am still alive every seven minutes
    setInterval ()->
      $subscription.publishTo "/users/#{$scope.current_user.id}", {action: 'still_alive', user: $scope.current_user}
    , 420000

    # remove friends that didn't seen for ten minutes
    setInterval ()->
      current_time = Date.now()
      for own friend_id, last_seen_at of $scope.friends_last_seen_at
        if current_time - last_seen_at > 600000 # the user didn't seen for more than ten minutes
          delete $scope.friends_last_seen_at[friend_id]
          i = _.indexOf(_.pluck($channels.online_friends_channel.users, 'id'), parseInt(friend_id))
          if i > -1
            $channels.online_friends_channel.users.splice(i,1)
            $scope.$apply()
    ,600000

    # send user_left message on beforeunload
    window.onbeforeunload = ()->
      $subscription.publishTo "/users/#{$scope.current_user.id}", {action: 'user_left', user: $scope.current_user}
      return null

  $scope.receiveFriendPulse = (msg)->
    friend = msg.user
    if msg.action == 'user_left'
      delete $scope.friends_last_seen_at[friend.id]
      i = _.indexOf(_.pluck($channels.online_friends_channel.users, 'id'), parseInt(friend.id))
      if i > -1
        $channels.online_friends_channel.users.splice(i,1)
        $scope.$apply()
    else if msg.action == "user_joined" || msg.action == "still_alive"
      # if the friend wasn't seen before, then add him to the online_friends_channel
      unless $scope.friends_last_seen_at[friend.id]
        $channels.online_friends_channel.users.push(friend)
        $scope.$apply()
        # send a pulse so that this friend can receive
        $subscription.publishTo "/users/#{$scope.current_user.id}", {action: 'user_joined', user: $scope.current_user}
      else
        # the friend is already seen, but it may happened that he left then entered in less than ten minutesin,
        # in this case although I still know about him, he don't know about me, so I will notify hin
        if msg.action == "user_joined"
          $subscription.publishTo "/users/#{$scope.current_user.id}", {action: 'still_alive', user: $scope.current_user}
      
      # update frined_last_seen_at to now
      $scope.friends_last_seen_at[friend.id] = Date.now()


  $scope.$watchCollection ()->
    $channels.active_channels
  , (new_channels, old_channels)->
    for channel in _.difference(new_channels, old_channels)
      channel.users = []
      if channel.id != -1

        $subscription.subscribeTo "/channels/#{channel.id}/users/#{$scope.current_user.id}", (data, subscribed_channel)->
          obj = JSON.parse(data)
          unless _.find(channel.users, (u) -> u.id == obj.user.id)
            channel.users.push(obj.user)
            $scope.$apply()
        $subscription.subscribeTo "/channels/#{channel.id}", (data, subscribed_channel)->
          obj = JSON.parse(data)
          if obj.action == 'user_joined'
            if $scope.current_user.id != obj.user.id
              unless _.find(channel.users, (u) -> u.id == obj.user.id)
                channel.users.push(obj.user)
                $scope.$apply()
              # inform this new user that I am on the channel
              $subscription.publishTo "/channels/#{channel.id}/users/#{obj.user.id}", {user: $scope.current_user}
          else if obj.action == 'user_left'
            i = _.indexOf(_.pluck(channel.users, 'id'), parseInt(obj.user_id))
            if(i > -1)
              channel.users.splice(i,1)
              $scope.$apply()
        
        $subscription.publishTo "/channels/#{channel.id}", {action: 'user_joined', user: $scope.current_user}
   
    for channel in _.difference(old_channels, new_channels)
      $subscription.unsubscribeFrom "/channels/#{channel.id}"
      $subscription.publishTo "/channels/#{channel.id}", {action: 'user_left', user_id: "#{$scope.current_user.id}"}
]