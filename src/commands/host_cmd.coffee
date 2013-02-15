prompt = require 'prompt'
async = require 'async'
fs = require 'fs'
path = require 'path'
hashish = require 'hashish'
child_process = require('child_process')
FlirtyUtils = require '../flirty/utils'
require 'colors'

module.exports = (options, callback)->
  async.auto {
    promptForOptions: 
      (callback)->
        _promptForMissingOptions options, callback
    sanitizeOptions: [
      'promptForOptions'
      (callback, results)->
        completeOptions = hashish.merge results.promptForOptions, options
        completeOptions.username = if completeOptions.username?.length > 1 then completeOptions.username else null
        completeOptions.password = if completeOptions.password?.length > 1 then completeOptions.password else null
        callback null, completeOptions
    ]
    checkFlirtyPort: [
      'sanitizeOptions'
      (callback, results)->
        FlirtyUtils.testPortIsAvailable results.sanitizeOptions.port, callback   
    ]
    spawnHost: [
      'checkFlirtyPort'
      (callback, results)->
        _spawnHost results.sanitizeOptions, callback
    ]
  }, (err, results)->
    throw err if err
    callback err if callback?

_promptForMissingOptions = (options, callback)->
  prompt.message = "Flirty Host"
  prompt.override = options
  prompt.get _promptSchema, (err, results)->
    callback err, results

_spawnHost = (options, callback)->
  daemonScriptPath = require.resolve('../daemon_host')
  command = if path.extname(daemonScriptPath).match(/coffee$/) then 'coffee' else 'node'  
  daemonScriptCommands = _buildScriptCommands daemonScriptPath, options

  spawnOptions = {
    env: process.env
    cwd: process.cwd()
    stdio: 'inherit'
  }

  if options.daemon
    console.log "Flirt DAEMONIZED! Use `flirt list` to see which processes are running.".red
    outLog = fs.openSync './flirty.log', 'a'
    errLog = fs.openSync './flirty.log', 'a'
    spawnOptions.detached = true 
    spawnOptions.stdio = ['ignore', outLog, errLog]

  child = child_process.spawn command, daemonScriptCommands, spawnOptions
  child.unref() if options.daemon
  callback null


_buildScriptCommands = (scriptPath, options)->
  scriptOptions = [ 
    scriptPath
    '--folder', path.resolve(options.folder)
    '--port', options.port
  ]
  scriptOptions = scriptOptions.concat ['--label', options.label] if options.label
  scriptOptions = scriptOptions.concat ['--username', options.username] if options.username
  scriptOptions = scriptOptions.concat ['--password', options.password] if options.password
  scriptOptions

# defines the properties to prompt the user for if not provided at the cmd
# line
_promptSchema = {
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
      description: "Protect content with a username?"
    password:
      hidden: true
      description: "Protect content with a password?"
}