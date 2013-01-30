FlirtyHost = require '../lib/flirty/host'
http = require 'http'
path = require 'path'
optimist = require 'optimist'
prompt = require 'prompt'

require 'colors'

schema = {
  properties:
    folder:
      required: true
      default: "./"
      description: "Which folder do you want to host?"
    port:
      default: 3333
      required: true
      description: "What port do you want to host on?"
    username:
      description: "Protect content with a username"
    password:
      hidden: true
      description: "Protect content with a password"
}

exports.run = ->
  prompt.message = "Flirty Host"
  prompt.override = optimist.argv
  prompt.get schema, (err, results)->
    flirty_opts = {}
    flirty_opts.username = if results.username.length > 1 then results.username else null
    flirty_opts.password = if results.password.length > 1 then results.password else null

    dir = path.resolve process.cwd(), results.folder

    app = FlirtyHost dir, flirty_opts
    http.createServer(app).listen results.port, (err)->
      console.log "%s hosted on http:localhost: %s", dir.green, results.port.green



