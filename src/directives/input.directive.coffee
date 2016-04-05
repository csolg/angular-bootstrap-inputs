angular
  .module 'boostrapInputs'
  .directive 'inputEnum', ()->
    {
      strict: 'E'
      templateUrl: 'templates/input-enum.html'
      scope: {
        model: '='
      }
      replace: true
      link: (scope, element, attrs)->
        scope.dtLabel = attrs.dtLabel
        scope.elementId = 'input_' + scope.$id

        scope.options = []
        enums = JSON.parse(attrs.dtEnum)
        for value, label of enums
          scope.options.push { value: value, label: label }
    }

  .directive 'inputString', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-string.html'
      scope: {
        model: '='
      }
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
        scope.required = attrs.required != undefined
    }

  .directive 'inputHidden', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-hidden.html'
      scope: {
        model: '='
      }
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
    }

  .directive 'inputMap', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-map.html'
      scope: {
        model: '='
      }
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
        scope.mapId = 'field_' + scope.$id
        scope.required = attrs.required != undefined
        scope.longitudeField = scope.field
        scope.latitudeField = scope.field.model.fieldByName scope.field.latitude
        scope.zoomField = scope.field.model.fieldByName scope.field.zoom

        scope.$watch ()->
          scope.field.getValue()
        , (newValue, oldValue)->
          longitude = scope.longitudeField.value()
          latitude = scope.latitudeField.value()
          zoom = scope.zoomField.value()
          if longitude && latitude && zoom
            scope.map = new google.maps.Map $('#' + scope.mapId)[0],
              center: new google.maps.LatLng(latitude, longitude)
              zoom: zoom
            scope.marker = new google.maps.Marker
              position: { lat: latitude, lng: longitude }
              map: scope.map
            scope.map.addListener 'click', (e)->
              scope.latitudeField.value(e.latLng.lat())
              scope.longitudeField.value(e.latLng.lng())
              scope.zoomField.value(scope.map.getZoom())
              scope.marker.setPosition e.latLng
    }

  .directive 'inputText', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-text.html'
      scope: {
        model: '='
      }
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
        scope.required = attrs.required != undefined
    }

  .directive 'inputDate', ()->
    {
      strict: 'E'
      templateUrl: 'templates/input-date.html'
      scope: {
        model: '='
      }
      replace: true
      link: (scope, element, attrs)->
        scope.dtLabel = attrs.dtLabel
        scope.elementId = 'input_' + scope.$id

        scope.day = 1
        scope.month = 1
        scope.year = 2000

        scope.days = [1..31]
        scope.monthes = []
        month_names = JSON.parse(attrs.dtMonthes)
        for month in [1..12]
          scope.monthes.push { label: month_names[month], value: month }
        currentYear = new Date().getFullYear()
        scope.years = [currentYear - 70..currentYear - 5].reverse()
    }

  .directive 'inputInteger', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-integer.html'
      scope:
        model: '='
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
        scope.required = attrs.required != undefined
    }

  .directive 'inputSelect', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-select.html'
      scope: {
        model: '='
      }
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
        scope.options = element.data('collection')
        scope.required = attrs.required != undefined
    }

  .directive 'inputImage', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-image.html'
      scope:
        model: '='
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
        scope.required = attrs.required != undefined

        element.find('input').bind 'change', (changeEvent) ->
          file = changeEvent.target.files[0]
          reader = new FileReader()

          reader.onload = (loadEvent) ->
            scope.$apply ->
              scope.field.value loadEvent.target.result

          reader.readAsDataURL file
    }

  .directive 'inputTime', ()->
    {
      require: '^form'
      strict: 'E'
      templateUrl: 'templates/input-time.html'
      scope:
        model: '='
      replace: true
      link: (scope, element, attrs, form)->
        scope.form = form
        scope.label = attrs.label
        scope.elementId = 'input_' + scope.$id
        scope.required = attrs.required != undefined

        scope.options = []
        for h in [0..23]
          for min in [0, 30]
            time = ('0' + h).slice(-2) + ':' + ('0' + min).slice(-2)
            scope.options.push { name: time, value: time }
    }
