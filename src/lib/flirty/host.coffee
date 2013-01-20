"use strict"
express = require 'express'

module.exports = (folder, password)->
  app = express()
  app.use express.static folder if folder?
  return app