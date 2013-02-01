FlirtyHost = require './flirty/host'
options = require('optimist')
  .alias('f', 'folder')
  .alias('p', 'port')
  .alias('u', 'username')
  .alias('s', 'password')
  .alias('i', 'identifier')
  .default('identifier', 'flirty')
  .argv

# module.exports = (dir, port, options)->

_daemonize = ->
  foreverize = require('foreverize')({
    logDir: 'logs'
    uid: options.identifier+options.port
  })
  unless foreverize.isMaster
    _launch options.f, options.p, options.u, options.s

_launch = (dir, port, username, password)->
  app = FlirtyHost dir, { username: username, password: password }
  app.listen port, (err)->
    console.log "Daemon %s host on http://localhost:%s", dir, port

# console.log options
# _longRun()
_daemonize()
