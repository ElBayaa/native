App.factory 'User', ['$resource', ($resource) ->
  
  $resource("/api/#{App.version}/users/:user_id", {user_id: '@id'}, { update_current_user: { method: 'PUT' }})
  
]
