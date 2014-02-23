(function() {
  var app;

  app = angular.module('app', []);

  app.controller('AppController', function($scope) {
    var calculate;
    $scope.devices = [
      {
        name: 'Samsung Galaxy S II',
        width: 480,
        height: 800,
        dpi: 218
      }, {
        name: 'Samsung Galaxy S III',
        width: 720,
        height: 1280,
        dpi: 306
      }
    ];
    $scope.specs = angular.copy($scope.devices[0]);
    calculate = function() {
      var res, spec;
      spec = $scope.specs;
      res = ($scope.result || ($scope.result = {}));
      res.inchWidth = (spec.width / spec.dpi).toFixed(2);
      res.pxWidth = spec.width;
      res.dpWidth = (160 * spec.width / spec.dpi).toFixed(0);
      res.inchHeight = (spec.height / spec.dpi).toFixed(2);
      res.pxHeight = spec.height;
      res.dpHeight = (160 * spec.height / spec.dpi).toFixed(0);
      res.dpi = spec.dpi;
      res.size = Math.sqrt(Math.pow(spec.width / spec.dpi, 2) + Math.pow(spec.height / spec.dpi, 2)).toFixed(2);
      res.sw = Math.min(res.dpHeight, res.dpWidth);
      if (res.dpi >= 640) {
        return res.density = 'xxxhdpi';
      } else if (res.dpi >= 480) {
        return res.density = 'xxhdpi';
      } else if (res.dpi >= 320) {
        return res.density = 'xhdpi';
      } else if (res.dpi >= 240) {
        return res.density = 'hdpi';
      } else if (res.dpi >= 160) {
        return res.density = 'mdpi';
      } else if (res.dpi >= 120) {
        return res.density = 'ldpi';
      } else {
        return res.density = 'not classified';
      }
    };
    $scope.showSpec = function(spec) {
      return $scope.specs = angular.copy(spec);
    };
    $scope.removeSpec = function(spec) {
      var index;
      index = $scope.devices.indexOf(spec);
      if (index >= 0) {
        return $scope.devices.splice(index, 1);
      }
    };
    $scope.saveSpec = function(spec) {
      var saved;
      spec = angular.copy(spec);
      saved = false;
      $scope.devices.forEach(function(item, index) {
        if (item.name === spec.name) {
          $scope.devices[index] = spec;
          return saved = true;
        }
      });
      if (!saved) {
        return $scope.devices.push(spec);
      }
    };
    $scope.$watch('specs.width', calculate);
    $scope.$watch('specs.height', calculate);
    return $scope.$watch('specs.dpi', calculate);
  });

  app.directive('ngDevice', function() {
    return function($scope, $element, $attrs) {
      var draw, svg;
      svg = SVG($element[0].id);
      draw = function() {
        var spec;
        svg.clear();
        spec = $scope.specs;
        svg.size(spec.width + 20, spec.height + 20);
        svg.rect(spec.width, spec.height).move(20, 20);
        svg.rect(spec.width, 1).move(20, 10);
        svg.rect(1, 10).move(20, 5);
        svg.rect(1, 10).move(spec.width + 19, 5);
        svg.rect(1, spec.height).move(10, 20);
        svg.rect(10, 1).move(5, 20);
        return svg.rect(10, 1).move(5, spec.height + 19);
      };
      $scope.$watch('specs.width', draw);
      $scope.$watch('specs.height', draw);
      return $scope.$watch('specs.dpi', draw);
    };
  });

}).call(this);
