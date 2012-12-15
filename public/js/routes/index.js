var __slice = [].slice;

define(["app/server", "app/pulse", "templates/index", "templates/image"], function(server, pulse, indexTempl, imageTempl) {
  return {
    show: function() {
      var addImage, chan, img;
      chan = pulse.channel('main');
      img = [];
      addImage = function() {
        var image, images, nu, _i, _len, _results;
        images = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        _results = [];
        for (_i = 0, _len = images.length; _i < _len; _i++) {
          image = images[_i];
          nu = $(imageTempl({
            image: image
          }));
          _results.push($("#images").prepend(nu).isotope('reloadItems').isotope({
            sortBy: 'original-order'
          }));
        }
        return _results;
      };
      return server.ready(function() {
        return server.getImages(function(images) {
          var $container;
          img = img.concat(images);
          $("#main").html(indexTempl());
          $container = $("#images");
          $container.isotope({
            itemSelector: '.item'
          });
          addImage.apply(null, images);
          chan.on('new', function(image) {
            img.push(image);
            return addImage(image);
          });
          return setInterval(function() {
            return $container.isotope('reLayout');
          }, 100);
        });
      });
    }
  };
});
