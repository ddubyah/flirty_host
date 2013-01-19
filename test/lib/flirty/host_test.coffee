express = require 'express'
Flirty = require '../../../src/lib/flirty'
http = require 'http'

describe "Flirty.Host", ->
  beforeEach ->
    @sut = Flirty.host()

  it "should exist", ->
    expect(@sut).to.exist

  it "should be able to start and stop as a server", (done)->
    _server = http.createServer @sut
    _server.listen 3434, (err)->
      process.nextTick ->
        _server.close (err)->
          done()