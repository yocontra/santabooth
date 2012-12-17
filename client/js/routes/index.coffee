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
    play = false

    addImage = (images...) ->
      for image in images
        nu = $ imageTempl image: image
        $("#images").prepend(nu)
          .isotope('reloadItems')
          .isotope(sortBy: 'original-order')


    drawWebcam = (vid, ctx) ->
      requestAnimFrame ->
        drawWebcam vid, ctx

      # face
      ctx.drawImage vid, (vid.width/2), (vid.height/2)-100, 200, 200, 80, 140, 100, 100

    drawSanta = (ctx) ->
      _img = new Image
      _img.onload = ->
        ctx.drawImage _img, 0, 0
      _img.src = "img/santa.png"

    takeImage = ->
      canvas = document.getElementById "myCanvas"
      uri = canvas.toDataURL "image/png"
      chan.emit 'new', uri

    $("#main").html indexTempl()
    canvas = document.getElementById 'myCanvas'
    ctx = canvas.getContext '2d'
    drawSanta ctx
        
    server.ready ->
      server.getImages (images) ->
        img = img.concat images

        $("#grabButton").click takeImage

        navigator.getUserMedia
          video: true
        , (s) ->
          vid = document.getElementById 'myVideo'
          url = window.URL.createObjectURL s
          vid.src = url
          drawWebcam vid, ctx, 0, 0

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