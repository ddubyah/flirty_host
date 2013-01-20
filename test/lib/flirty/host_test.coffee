express = require 'express'
Flirty = require '../../../src/lib/flirty'
http = require 'http'
connect = require 'connect'

path = require 'path'
fixtures = path.resolve(__dirname, '../../fixtures')

describe "Flirty.host()", ->

  it "should exist", ->
    expect(Flirty.host()).to.exist

  describe "When passed a folder", ->
    beforeEach ->
      @app = Flirty.host fixtures

    it "should serve the folder's contents at '/content'", (done)->
      request(@app).get('/content/index.txt')
        .expect "page 1", done 

  describe "When initialised with a password", ->
    beforeEach ->
      @app = Flirty.host fixtures, "somepass"

    it "should host a login page", (done)->
      request(@app).get('/sessions/login')
        .expect /<title>Login<\/title>/, done

    describe "before authentication", ->
      it "should redirect to the login page", (done)->
        request(@app).get('/content/index.txt')
          .expect 302, done
    