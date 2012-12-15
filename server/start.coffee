express = require 'express'
http = require 'http'
Vein = require 'vein'
Pulsar = require 'pulsar'
{join} = require 'path'

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

console.log "Server running on #{config.port}"