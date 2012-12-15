define ["app/server", "app/pulse", "templates/index", "templates/image"], (server, pulse, indexTempl, imageTempl) ->
  
  navigator.getUserMedia = 
    navigator.getUserMedia or
    navigator.webkitGetUserMedia or
    navigator.mozGetUserMedia or
    navigator.msGetUserMedia
  window.URL = window.URL or window.webkitURL

  o = show: ->
    chan = pulse.channel 'main'

    img = []

    addImage = (images...) ->
      for image in images
        nu = $ imageTempl image: image
        $("#images").prepend(nu)
          .isotope('reloadItems')
          .isotope(sortBy: 'original-order')


    takeImage = ->
      canvas = document.getElementById "myCanvas"
      uri = canvas.toDataURL "image/png"
      chan.emit 'new', uri

    drawImage = ->
      canvas = document.getElementById "myCanvas"
      ctx = canvas.getContext '2d'
      _img = new Image
      _img.onload = ->
        ctx.drawImage _img, 0, 0
      _img.src = "img/santa.png"

    server.ready ->
      server.getImages (images) ->
        img = img.concat images
        $("#main").html indexTempl()

        drawImage()
        $("#grabButton").click ->
          takeImage()

        $container = $ "#images"
        $container.isotope
          itemSelector: '.item'

        addImage images...

        chan.on 'new', (image) ->
          img.push image
          addImage image

        setInterval ->
          $container.isotope 'reLayout'
        , 100
  return o