express = require 'express'
Flirty = require '../../../src/flirty'
http = require 'http'

path = require 'path'
fixtures = path.resolve(__dirname, '../../fixtures')

describe.only "Flirty.host()", ->

  it "should exist", ->
    expect(Flirty.host()).to.exist

  describe "When passed a folder", ->
    beforeEach ->
      @app = Flirty.host fixtures

    it "should serve the folder's contents at '/content'", (done)->
      request(@app).get('/content/index.txt')
        .end (err, res)->
          res.text.should.equal 'page 1'
          process.nextTick done

  describe "When initialised with a password", ->
    beforeEach ->
      @app = Flirty.host fixtures, "somepass"

    it "should host a login page", (done)->
      request(@app).get('/sessions/login')
        .end (err, res)->
          res.should.have.status 200
          res.should.be.html
          res.text.should.match( /<title>Login<\/title>/)
          process.nextTick done
     
    # it.skip "should redirect to the login page", (done)->
    #   request(@app).get('/content/index.txt')
    #     .end (err, res)->
    #       res.should.have.status 302
    #       process.nextTick done
    