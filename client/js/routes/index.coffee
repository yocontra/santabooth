define ["app/server", "app/pulse", "templates/index", "templates/image"], (server, pulse, indexTempl, imageTempl) ->
  show: ->
    chan = pulse.channel 'main'

    img = []

    addImage = (images...) ->
      for image in images
        nu = $ imageTempl image: image
        $("#images").prepend(nu)
          .isotope('reloadItems')
          .isotope(sortBy: 'original-order')



    server.ready ->
      server.getImages (images) ->
        img = img.concat images
        $("#main").html indexTempl()

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