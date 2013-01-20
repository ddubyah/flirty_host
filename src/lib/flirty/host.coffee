"use strict"
express = require 'express'
path = require 'path'

module.exports = (folder, password)->
  app = express()
  app.use express.static folder if folder?
  _hostFlirtyPages app
  return app

_hostFlirtyPages = (app)->
  flirtyPath = './public'
  app.use '/sessions', express.static flirtyPath