App.controller 'LanguagesCtrl', ['$scope', '$http', ($scope, $http) ->
  # Attributes accessible on the view
  $scope.languages = []
  $scope.selected_language = null

  $scope.setLanguages = () ->
    $scope.languages = languages
  
  $scope.viewLanguageChannels = (language) ->
    $scope.selected_language = language
    unless language.channels?
      $http.get "/api/#{App.version}/languages/#{language.id}/channels"
      .success (data)->
          language.channels = data
]