define ["app/server", "templates/index"], (server, indexTempl) ->
  show: ->
    server.ready ->
      server.getImages (images) ->
        $("#main").html indexTempl images: images