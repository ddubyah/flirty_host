forever = require 'forever'
FlirtyUtils = require '../flirty/utils'
async = require 'async'
prompt = require 'prompt'
require 'colors'

module.exports = (options)->
  async.auto {
    getAllFlirts: 
      (callback)->
        FlirtyUtils.getFlirts callback
    promptConfirm: [
      'getAllFlirts'
      (callback, results)->
        return callback null if options.force
        return callback null unless results.getAllFlirts.length > 0
        prompt.start()
        prompt.get _confirmationSchema, callback
    ]      
  }, (err, results)->
    if options.force || results.promptConfirm.confirm == 'Y'
      for flirt in results.getAllFlirts
        console.log "Stopping %s", flirt.details.uid.red
        forever.stop flirt.foreverIndex

_confirmationSchema = {
  properties: {
    confirm: {
      message: "Are you sure you want to stop all flirty processes? (Y/n)"
    }
  }
}