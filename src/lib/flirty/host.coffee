"use strict"
express = require 'express'
path = require 'path'
passport = require 'passport'
LocalStrategy = require 'passport-local'
hashish = require 'hashish'
routes = require './routes'

_defaults = {
  mountPath: '/content'
  sessionsPath: '/sessions'
}

_options = null

module.exports = (folder, password, opts={})->
  _options = hashish.merge _defaults, opts
  app = express()
  _configure app
  _protectContent app if password?
  _hostStaticFolder app, folder if folder?
  return app

_hostStaticFolder = (app, folder)->
  console.log "Hosting static folder: %s", folder
  app.use _options.mountPath, express.static(folder)

_protectContent = (app)->
  console.log "Protecting content"
  app.use _options.mountPath, _ensureAuthenticated

_configure = (app)->
  flirtyPath = './public'
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use express.logger('dev')
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.session secret: "flirty host"
  app.use express.methodOverride()
  app.use app.router

  app.use passport.initialize()
  app.use passport.session()

  app.get "#{_options.sessionsPath}/login", routes.sessions.new
  app.use "#{_options.sessionsPath}", express.static flirtyPath

_ensureAuthenticated = (req, res, next)->
  console.log "Protected? %s", req.isAuthenticated()
  return next() if req.isAuthenticated()
  res.redirect "#{_options.sessionsPath}/login"