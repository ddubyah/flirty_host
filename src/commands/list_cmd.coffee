forever = require 'forever'
async = require 'async'
require 'colors'
FlirtyUtils = require '../flirty/utils'

module.exports = ->
  async.auto {
    getFlirts: 
      (callback)->
        FlirtyUtils.getFlirts callback
    listFlirtyProcesses: [
      'getFlirts'
      (callback, results)->
        if results.getFlirts.length > 0
          console.log "[%s] %s : %s http://localhost:%s - %s", "index", "uid".yellow, "folder".green, "port".green, "pid"
          FlirtyUtils.listFlirts results.getFlirts
        else
          console.log "No flirty host processes running"
        callback null
    ]
  }, (err, results)->
    throw err if err

