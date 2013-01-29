"use strict"
express = require 'express'
path = require 'path'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
flash = require 'connect-flash'
hashish = require 'hashish'
routes = require './routes'

thirtyMinutes = 1000*60*30

console.log thirtyMinutes

_defaults = {
  mountPath: '/'
  sessionsPath: '/sessions'
  maxAge: thirtyMinutes # defaults to 30 minutes
  username: null
  password: null
  locals: {
    projectTitle: 'ProtectedPages'
    heading: 'Hold it!'
  }
}

_options = null

module.exports = (folder, opts={})->
  _options = hashish.merge _defaults, opts
  app = express()
  _configurePassport()
  _configure app
  _protectContent app if _options.password?
  _hostStaticFolder app, folder if folder?
  return app

_configurePassport = ->
  passport.serializeUser (user, done)->
    console.log "Serialize"
    done null, user.id

  passport.deserializeUser (id, done)->
    console.log "Deserialze"
    if id == 101
      done null, { id: 101 }
    else
      done null, { id: 101 }

  passport.use new LocalStrategy (uname, pword, done)->
    console.log "\nLocal login challenge\n  username: %s\n  password: %s", uname, pword
    return done null, false, { message: "Bad username" } if uname != _options.username
    return done null, false, { message: "Bad password" } if pword != _options.password
    done null, { id: 101 }


_configure = (app)->
  flirtyPath = path.resolve __dirname, '../../flirty_root'
  viewPath = path.resolve __dirname, '../../views'
  app.locals _options.locals
  app.set('views', viewPath);
  app.set('view engine', 'jade');
  app.use express.logger('dev')
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.session secret: "flirtyHost", cookie: maxAge: _options.maxAge
  app.use flash()
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.get "#{_options.sessionsPath}/login", routes.sessions.new
  app.use "#{_options.sessionsPath}", express.static flirtyPath

_protectContent = (app)->
  app.post _options.sessionsPath, passport.authenticate 'local', {
    failureRedirect: "#{_options.sessionsPath}/login"
    successRedirect: "/"
    failureFlash: true
  }

  app.get "#{_options.sessionsPath}/logout", (req, res)->
    console.log "Logging out"
    req.logout()
    res.redirect _options.mountPath

  app.use _options.mountPath, _ensureAuthenticated

_ensureAuthenticated = (req, res, next)->
  console.log "Authorised? %s", req.isAuthenticated()
  if req.isAuthenticated()
    console.log "You may pass"
    return next() 
  else
    console.log "Protected!"
    res.redirect "#{_options.sessionsPath}/login"

_hostStaticFolder = (app, folder)->
  console.log "Hosting static folder: %s", folder
  app.use _options.mountPath, express.static(folder)