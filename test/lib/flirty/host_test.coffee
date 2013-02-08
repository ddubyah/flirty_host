express = require 'express'
Flirty = require '../../../src/flirty'
http = require 'http'

path = require 'path'
fixtures = path.resolve(__dirname, '../../fixtures')



describe "Flirty.host()", ->

  it "should exist", ->
    expect(Flirty.host()).to.exist

  describe "When passed a folder", ->
    beforeEach ->
      @app = Flirty.host fixtures

    it "should serve the folder's contents at '/content'", (done)->
      request(@app).get('/index.txt')
        .end (err, res)->
          res.text.should.equal 'page 1'
          process.nextTick done

  describe "When initialised with a username and password", ->
    beforeEach ->
      @app = Flirty.host fixtures, {
        username: "doofus"
        password: "somepass"
      }

    it "should host a login page", (done)->
      request(@app).get('/sessions/login')
        .end (err, res)->
          res.should.have.status 200
          res.should.be.html
          res.text.should.match( /<title>Login<\/title>/)
          process.nextTick done
     
    it "should redirect unauthorised requests to the login page", (done)->
      request(@app).get('/index.txt')
        .end (err, res)->
          res.should.have.status 302
          res.should.have.header 'location', '/sessions/login'
          process.nextTick done

    describe "Logging in.", ->
      describe "with the proper credentials", ->          
        it "should redirect to the content", (done)->
          _postLoginDetails @app, 'doofus', 'somepass', (err, response)->
            response.should.have.header 'location', '/'
            done()

        it "should expect the credentials defined in the constructor", (done)->
          app = Flirty.host fixtures, {
            username: "bert"
            password: "earnie"
          }
          _postLoginDetails app, 'bert', 'earnie', (err, response)->
            response.should.have.header 'location', '/'
            done()

        describe "with bad credentials:", ->
          it "should redirect to the login page", (done)->
            _postLoginDetails @app, 'bad', 'credentials', (err, response)->
              response.should.have.header 'location', '/sessions/login'
              done()

_postLoginDetails = (app, username, password, onEnd)->
  console.log "Posting %s : %s", username, password
  request(app).post('/sessions')
    .send({ username: username, password: password})
    .end onEnd



    