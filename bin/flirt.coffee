#!/usr/bin/env coffee

FlirtyHost = require '../lib/flirty/host'
http = require 'http'

optimist = require 'optimist'
prompt = require 'prompt'

require 'colors'

schema = {
  properties:
    folder:
      required: true
      default: "./public"
      description: "Which folder do you want to host?"
    port:
      default: 3333
      required: true
      description: "What port do you want to host on?"
    username:
      description: "Protect content with a username"
    password:
      description: "Protect content with a password"
}

prompt.message = "Flirty Host"

prompt.override = optimist.argv

prompt.get schema, (err, results)->
  flirty_opts = {}
  flirty_opts.username = results.username if results.username?
  flirty_opts.password = results.password if results.password?

  app = FlirtyHost results.folder, flirty_opts
  
  http.createServer(app).listen results.port, (err)->
    console.log "%s hosted on http:localhost: %s", results.folder.green, results.port.green