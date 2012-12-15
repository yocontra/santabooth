
define(["app/server", "app/pulse", "templates/index"], function(server, pulse, indexTempl) {
  return {
    show: function() {
      var chan, img, render;
      chan = pulse.channel('main');
      img = [];
      render = function() {
        return $("#main").html(indexTempl({
          images: img
        }));
      };
      server.ready(function() {
        return server.getImages(function(images) {
          img = img.concat(images);
          return render();
        });
      });
      return chan.on('new', function(image) {
        img.push(image);
        return render();
      });
    }
  };
});
