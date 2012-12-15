express = require 'express'
http = require 'http'
Vein = require 'vein'
Pulsar = require 'pulsar'
{join} = require 'path'
images = require './images'

config = require './config'

app = express()
app.use express.static  join __dirname, '../public'

server = http.createServer(app).listen config.port

# RPC
rpc = Vein.createServer server
rpc.addFolder join __dirname, './services'

# Pulsar
pulse = Pulsar.createServer server
chan = pulse.channel 'main'

chan.on 'new', (img) ->
  images.push img

console.log "Server running on #{config.port}"