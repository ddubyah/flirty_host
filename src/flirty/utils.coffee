async = require 'async'
forever = require 'forever'
require 'colors'

exports.listFlirts = (flirts)->
  flirts = [].concat flirts
  for flirt in flirts
    console.log "[%d] %s : %s http://localhost:%s - %s", 
      flirt.foreverIndex
      flirt.details.uid.yellow
      flirt.details.options[1].green # folder
      flirt.details.options[3].green # port
      flirt.details.pid

exports.findByFlirtyId = (flirtyUid, callback)->
  async.auto {
    getFlirts:
      (callback)->
        _getFlirts callback
    findFlirtById: [
      'getFlirts'
      (callback, results)->
        for flirt in results.getFlirts
          return callback(null, flirt) if flirt.details.uid == flirtyUid
        callback null, false
    ]
  }, (err, results)->
    callback err, results.findFlirtById

exports.testPortIsAvailable = (portnumber, callback)->
  # N.B. Only checks for ports used in forever processes at the moment
  _getFlirts (err, flirts)->
    for flirt in flirts
      return callback new Error "Port #{portnumber} not available" if flirt.details.options[3] == String(portnumber)
    callback null, true

_getFlirts = (callback)->
  async.auto {
    getForeverProcesses:
      (callback)->
        forever.list false, callback
    filterFlirts: [
      'getForeverProcesses'
      (callback, results)->
        flirts = []
        return callback null, [] unless results.getForeverProcesses?
        for process, index in results.getForeverProcesses
          if _isFlirtyHost process
            flirts = flirts.concat {
              foreverIndex: index
              details: process
            }
        callback null, flirts
    ]
  },(err, results)->
    callback err, results.filterFlirts

_isFlirtyHost = (foreverProcess)->
  flirtyRegEx = /flirty.host.+daemonHost/i
  flirtyRegEx.test foreverProcess.file


exports.getFlirts = _getFlirts
