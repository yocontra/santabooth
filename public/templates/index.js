define(function(){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div class="row-fluid"><div class="span12"><div class="hero-unit"><canvas id="myCanvas"></canvas><button class="btn">Grab</button></div><div class="row-fluid">'),function(){if("number"==typeof images.length)for(var e=0,t=images.length;e<t;e++){var n=images[e];buf.push('<div class="well span4"><img'),buf.push(attrs({src:""+n+"",height:"450",width:"360"},{src:!0,height:!0,width:!0})),buf.push("/></div>")}else{var t=0;for(var e in images){t++;var n=images[e];buf.push('<div class="well span4"><img'),buf.push(attrs({src:""+n+"",height:"450",width:"360"},{src:!0,height:!0,width:!0})),buf.push("/></div>")}}}.call(this),buf.push("</div></div></div>")}return buf.join("")}})