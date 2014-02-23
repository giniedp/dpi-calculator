app = angular.module 'app', []

app.controller 'AppController', ($scope) ->

  $scope.devices = [{
    name: 'Samsung Galaxy S II',
    width: 480,
    height: 800,
    dpi: 218
  },{
    name: 'Samsung Galaxy S III',
    width: 720,
    height: 1280,
    dpi: 306
  }]
  $scope.specs = angular.copy $scope.devices[0]

  calculate = ->
    spec = $scope.specs
    res = ($scope.result ||= {})
    res.inchWidth = (spec.width / spec.dpi).toFixed(2)
    res.pxWidth = spec.width
    res.dpWidth = (160 * spec.width / spec.dpi).toFixed(0)

    res.inchHeight = (spec.height / spec.dpi).toFixed(2)
    res.pxHeight = spec.height
    res.dpHeight = (160 * spec.height / spec.dpi).toFixed(0)

    res.dpi = spec.dpi
    res.size = Math.sqrt(Math.pow(spec.width / spec.dpi, 2) + Math.pow(spec.height / spec.dpi, 2)).toFixed(2)
    res.sw = Math.min(res.dpHeight, res.dpWidth)

    if res.dpi >= 640
      res.density = 'xxxhdpi'
    else if res.dpi >= 480
      res.density = 'xxhdpi'
    else if res.dpi >= 320
      res.density = 'xhdpi'
    else if res.dpi >= 240
      res.density = 'hdpi'
    else if res.dpi >= 160
      res.density = 'mdpi'
    else if res.dpi >= 120
      res.density = 'ldpi'
    else
      res.density = 'not classified'

  $scope.showSpec = (spec) ->
    $scope.specs = angular.copy spec

  $scope.removeSpec = (spec) ->
    index = $scope.devices.indexOf(spec)
    $scope.devices.splice(index, 1) if index >= 0

  $scope.saveSpec = (spec) ->
    spec = angular.copy(spec)
    saved = false
    $scope.devices.forEach (item, index) ->
      if (item.name == spec.name)
        $scope.devices[index] = spec
        saved = true
    $scope.devices.push(spec) if !saved

  $scope.$watch 'specs.width', calculate
  $scope.$watch 'specs.height', calculate
  $scope.$watch 'specs.dpi', calculate

app.directive 'ngDevice', () ->
  ($scope, $element, $attrs) ->

    svg = SVG($element[0].id)

    draw = ->
      svg.clear();
      spec = $scope.specs
      svg.size(spec.width + 20, spec.height + 20)
      svg.rect(spec.width, spec.height).move(20, 20)
      svg.rect(spec.width, 1).move(20, 10)
      svg.rect(1, 10).move(20, 5)
      svg.rect(1, 10).move(spec.width + 19, 5)

      svg.rect(1, spec.height).move(10, 20)
      svg.rect(10, 1).move(5, 20)
      svg.rect(10, 1).move(5, spec.height + 19)

    $scope.$watch 'specs.width', draw
    $scope.$watch 'specs.height', draw
    $scope.$watch 'specs.dpi', draw