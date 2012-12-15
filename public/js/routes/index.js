
define(["app/server", "templates/index"], function(server, indexTempl) {
  return {
    show: function() {
      return server.ready(function() {
        return server.getImages(function(images) {
          return $("#main").html(indexTempl({
            images: images
          }));
        });
      });
    }
  };
});
