argumentum = require 'argumentum'
require 'colors'

commands = require './commands'

exports.run = ->
  argumentum.load(cliConfig).parse()

cliConfig = 
  script: 'flirt'
  commands:
    host:
      help: 'Host a static web folder'
      options:
        folder:
          help: 'The folder you want to host'
          metavar: 'DIRECTORY'
          required: yes
          default: './'
          position: 1
        port:
          help: 'The port you wish to host on'
          abbr: 'p'
        username:
          help: 'The username you want to use'
          abbr: 'u'
        password:
          help: 'The password you want to protect the content with'
          abbr: 's'
        label:
          help: 'Combined with the port number to generate a process.'
          abbr: 'l'
          default: 'flirty'
        daemon:
          help: 'Run as daemonized, background process'
          abbr: 'd'
          flag: yes
      callback: (options)->
        delete options['port'] unless String(options.port).match /^\d{4}$/
        commands.host options

    list:
      help: 'List all running flirty processes'
      callback: (options)->
        commands.list options

    stop:
      help: 'Stop a running Flirty Host'
      options: 
        uid:
          help: 'The uid of the host you want to stop . e.g. flirty3333'
          abbr: 'i'
          position: 1
          required: yes
      callback: (options)->
        commands.stop options.uid

    stopall:
      help: 'Stop all Flirty Hosts'
      options:
        force:
          help: 'skips confirmation'
          abbr: 'f'
          flag: yes
      callback: (options)->
        commands.stopAll options
