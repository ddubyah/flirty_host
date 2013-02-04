forever = require 'forever'
FlirtyUtils = require '../flirty/utils'
require 'colors'

module.exports = (processId)->
  FlirtyUtils.findByFlirtyId processId, (err, flirt)->
    if flirt
      console.log "Stopping: %s at index %d", processId, flirt.foreverIndex
      forever.stop flirt.foreverIndex
    else
      console.log "Flirty Host %s not found", processId.yellow
