define ["app/server", "app/pulse", "templates/index"], (server, pulse, indexTempl) ->
  show: ->
    chan = pulse.channel 'main'

    img = []
    render = ->
      $("#main").html indexTempl images: img

    server.ready ->
      server.getImages (images) ->
        img = img.concat images
        render()

    chan.on 'new', (image) ->
      img.push image
      render()

