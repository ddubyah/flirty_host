Flirty = require '../src/flirty'
http = require 'http'
express = require 'express'

flirt = Flirty.host(__dirname + '/fixtures', 'somepass')

app = http.createServer(flirt).listen 3333, (err)-> 
  console.log "Server started"


