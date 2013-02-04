FlirtyHost = require './flirty/host'
http = require 'http'
path = require 'path'
optimist = require 'optimist'
prompt = require 'prompt'
path = require 'path'
fork = require('child_process').fork
spawn = require('child_process').spawn
fs = require 'fs'
forever = require 'forever'

cmd_options = optimist
  .alias('d', 'daemonize')
  .alias('i', 'identifier')
  .alias('f', 'folder')
  .alias('u', 'username')
  .alias('s', 'password')
  .alias('p', 'port')
  .alias('l', 'list')
  .default('identifier', 'flirty')
  .argv

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
  prompt.override = cmd_options
  prompt.get schema, (err, results)->

    flirty_opts = {}
    flirty_opts.username = if results.username.length > 1 then results.username else null
    flirty_opts.password = if results.password.length > 1 then results.password else null

    dir = path.resolve process.cwd(), results.folder
    console.log "Launching %s", dir
    console.log cmd_options.label
    if cmd_options.d
      _spawnDaemon dir, results.port, flirty_opts
    else if cmd_options.l
      console.log "Listing Flirty Processes"
    else
      _hostFolder dir, results.port, flirty_opts

_hostFolder = (folder, port, options={})->
  console.log "Starting host on %s", port
  app = FlirtyHost folder, options
  app.listen port, (err)->
    throw err if err
    console.log "%s hosted on http://localhost:%s", folder.green, String(port).green

_spawnDaemon = (folder, port, options={})->
  console.log "Flirty Daemon"
  daemonPath = require.resolve('./daemonHost')
  out = fs.openSync './flirty.log', 'a'
  err = fs.openSync './flirty.log', 'a'

  command = if path.extname(daemonPath).match(/coffee$/) then 'coffee' else 'node'

  child = spawn command, [
    daemonPath,
    '-f', folder, 
    '-p', port, 
    '-i', cmd_options.identifier,
    '-u', options.username, 
    '-s', options.password], {
      env: process.env
      cwd: process.cwd()
      detached: true
      stdio: ['ignore', out, out]
    }
    forever.list false, (err, data)->
      # console.log "Processes\n" + data
      console.dir data
    child.unref()
    # process.exit()$--
