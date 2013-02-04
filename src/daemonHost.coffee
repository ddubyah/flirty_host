FlirtyHost = require './flirty/host'
path = require 'path'
options = require('optimist')
  .alias('f', 'folder')
  .alias('p', 'port')
  .alias('u', 'username')
  .alias('s', 'password')
  .alias('l', 'label')
  .default('label', 'flirty')
  .argv

_daemonize = ->
  foreverize = require('foreverize')({
    logDir: 'logs'
    uid: options.label+options.port
  })
  unless foreverize.isMaster
    _launch options.folder, options.port, options.username, options.password

_launch = (dir, port, username, password)->
  app = FlirtyHost dir, { username: username, password: password }
  app.listen port, (err)->
    console.log "Hosting %s on http://localhost:%s", dir, port

_daemonize()
