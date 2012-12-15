define ["app/server", "app/pulse", "templates/index", "templates/image"], (server, pulse, indexTempl, imageTempl) ->
  
  navigator.getUserMedia = 
    navigator.getUserMedia or
    navigator.webkitGetUserMedia or
    navigator.mozGetUserMedia or
    navigator.msGetUserMedia
  window.URL = window.URL or window.webkitURL
  
  `
  window.requestAnimFrame = (function(){
      return  window.requestAnimationFrame       || 
              window.webkitRequestAnimationFrame || 
              window.mozRequestAnimationFrame    || 
              window.oRequestAnimationFrame      || 
              window.msRequestAnimationFrame     || 
              function( callback ){
                window.setTimeout(callback, 1000 / 60);
              };
    })();
  `

  o = show: ->
    chan = pulse.channel 'main'

    img = []

    addImage = (images...) ->
      for image in images
        nu = $ imageTempl image: image
        $("#images").prepend(nu)
          .isotope('reloadItems')
          .isotope(sortBy: 'original-order')


    drawWebcam = (stream) -> ->
      vid = document.getElementById 'myVideo'
      url = window.URL.createObjectURL stream
      vid.src = url
      canvas = document.getElementById "myCanvas"
      ctx = canvas.getContext '2d'

      # santa
      _img = new Image
      _img.onload = ->
        ctx.drawImage _img, 0, 0
      _img.src = "img/santa.png"


    takeImage = ->
      canvas = document.getElementById "myCanvas"
      uri = canvas.toDataURL "image/png"
      chan.emit 'new', uri

    server.ready ->
      server.getImages (images) ->
        img = img.concat images
        $("#main").html indexTempl()

        $("#grabButton").click takeImage

        navigator.getUserMedia
          video: true
        , (s) ->
          requestAnimFrame drawWebcam s
        , (e) -> 
          console.log e

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