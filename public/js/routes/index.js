var __slice = [].slice;

define(["app/server", "app/pulse", "templates/index", "templates/image"], function(server, pulse, indexTempl, imageTempl) {
  var o;
  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
  window.URL = window.URL || window.webkitURL;
  
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
  ;

  o = {
    show: function() {
      var addImage, chan, drawWebcam, img, play, takeImage;
      chan = pulse.channel('main');
      img = [];
      play = false;
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
      drawWebcam = function(vid, ctx) {
        var _img;
        requestAnimFrame(function() {
          return drawWebcam(vid, ctx);
        });
        _img = new Image;
        _img.onload = function() {
          return ctx.drawImage(_img, 0, 0);
        };
        _img.src = "img/santa.png";
        return ctx.drawImage(vid, vid.width / 2, (vid.height / 2) - 100, 200, 200, 80, 140, 100, 100);
      };
      takeImage = function() {
        var canvas, uri;
        canvas = document.getElementById("myCanvas");
        uri = canvas.toDataURL("image/png");
        return chan.emit('new', uri);
      };
      return server.ready(function() {
        return server.getImages(function(images) {
          var $container;
          img = img.concat(images);
          $("#main").html(indexTempl());
          $("#grabButton").click(takeImage);
          navigator.getUserMedia({
            video: true
          }, function(s) {
            var canvas, ctx, url, vid;
            vid = document.getElementById('myVideo');
            url = window.URL.createObjectURL(s);
            vid.src = url;
            canvas = document.getElementById('myCanvas');
            ctx = canvas.getContext('2d');
            return drawWebcam(vid, ctx, 0, 0);
          }, function(e) {
            return console.log(e);
          });
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
  return o;
});
